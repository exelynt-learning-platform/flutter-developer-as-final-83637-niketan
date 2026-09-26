import 'dart:convert';

import 'package:employee_management/modules/authentication/data/repository/auth_repository_impl.dart';
import 'package:employee_management/modules/authentication/domain/repository/auth_repository.dart';
import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:employee_management/modules/authentication/presentation/view/login_screen.dart';
import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/data/repository/employee_dashboard_repo_impl.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/repository/employee_dashboard_repo.dart';
import 'package:employee_management/modules/employee_dashboard/domain/usecase/get_all_employees_usecase.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/view/employee_dashboard_mobile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockEmployeeDashboardRepo extends Mock implements EmployeeDashboardRepo {}

class MockHttpClient extends Mock implements http.Client {}

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeAuthCredential extends Fake implements AuthCredential {}

class FakeUri extends Fake implements Uri {}

class FakeGetAllEmployeesUseCase extends GetAllEmployeesUseCase {
  final List<GetAllEmployeesAttributeModel> employees;

  FakeGetAllEmployeesUseCase({this.employees = const []});

  @override
  Future<List<GetAllEmployeesAttributeModel>> getAllEmployees() async => employees;

  @override
  Future<bool> createEmployee(CreateEmployeeRequestModel request) async => true;

  @override
  Future<bool> updateEmployee(String id, CreateEmployeeRequestModel request) async => true;

  @override
  Future<bool> deleteEmployee(String id) async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
    registerFallbackValue(FakeUri());
  });

  group('AuthRepositoryImpl', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      repository = AuthRepositoryImpl(firebaseAuth: mockFirebaseAuth, googleSignIn: mockGoogleSignIn);
    });

    test('login delegates to Firebase Auth and returns user credential', () async {
      final userCredential = MockUserCredential();

      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123'),
      ).thenAnswer((_) async => userCredential);

      final result = await repository.login(email: 'test@example.com', password: 'password123');

      expect(result, same(userCredential));
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123')).called(1);
    });

    test('register updates display name and returns credential', () async {
      final userCredential = MockUserCredential();
      final createdUser = MockUser();

      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(email: 'test@example.com', password: 'password123'),
      ).thenAnswer((_) async => userCredential);
      when(() => userCredential.user).thenReturn(createdUser);
      when(() => createdUser.updateDisplayName('Jane')).thenAnswer((_) async {});
      when(() => createdUser.reload()).thenAnswer((_) async {});

      final result = await repository.register(name: 'Jane', email: 'test@example.com', password: 'password123');

      expect(result, same(userCredential));
      verify(() => createdUser.updateDisplayName('Jane')).called(1);
      verify(() => createdUser.reload()).called(1);
    });

    test('forgotPassword delegates to FirebaseAuth', () async {
      when(() => mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com')).thenAnswer((_) async {});

      await repository.forgotPassword(email: 'test@example.com');

      verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com')).called(1);
    });

    test('signInWithGoogle authenticates through Google and Firebase', () async {
      final googleUser = MockGoogleSignInAccount();
      final googleAuth = MockGoogleSignInAuthentication();
      final userCredential = MockUserCredential();

      when(() => mockGoogleSignIn.authenticate()).thenAnswer((_) async => googleUser);
      when(() => googleUser.authentication).thenReturn(googleAuth);
      when(() => googleAuth.idToken).thenReturn('token-id');
      when(() => mockFirebaseAuth.signInWithCredential(any(that: isA<AuthCredential>()))).thenAnswer((_) async => userCredential);

      final result = await repository.signInWithGoogle();

      expect(result, same(userCredential));
      verify(() => mockGoogleSignIn.authenticate()).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(any(that: isA<AuthCredential>()))).called(1);
    });

    test('logout signs out both Google and Firebase auth', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('EmployeeDashboardRepoImpl', () {
    late MockHttpClient mockClient;
    late EmployeeDashboardRepoImpl repository;

    setUp(() {
      mockClient = MockHttpClient();
      repository = EmployeeDashboardRepoImpl(client: mockClient);
    });

    test('getAllEmployees maps successful API response to domain models', () async {
      final responseBody = jsonEncode([
        {
          'id': '1',
          'name': 'Alice',
          'emailId': 'alice@example.com',
          'mobile': '9999999999',
          'country': 'India',
          'state': 'Maharashtra',
          'district': 'Mumbai',
          'email': 'alice@mail.com',
          'avatar': 'https://example.com/avatar.png',
          'createdAt': '2024-01-01',
        },
      ]);

      when(() => mockClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(responseBody, 200));

      final employees = await repository.getAllEmployees();

      expect(employees, hasLength(1));
      expect(employees.first.name, 'Alice');
      expect(employees.first.country, 'India');
      expect(employees.first.id, '1');
    });

    test('createEmployee returns true for 201 response', () async {
      final request = CreateEmployeeRequestModel(
        name: 'Bob',
        avatar: 'x',
        emailId: 'bob@example.com',
        mobile: '8888888888',
        country: 'India',
        state: 'Delhi',
        district: 'New Delhi',
        email: 'bob@alt.com',
      );

      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('', 201));

      final result = await repository.createEmployee(request);

      expect(result, isTrue);
    });

    test('updateEmployee returns true for 200 response', () async {
      final request = CreateEmployeeRequestModel(
        name: 'Updated',
        avatar: 'y',
        emailId: 'updated@example.com',
        mobile: '7777777777',
        country: 'USA',
        state: 'Texas',
        district: 'Austin',
        email: 'updated@alt.com',
      );

      when(
        () => mockClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      final result = await repository.updateEmployee('abc', request);

      expect(result, isTrue);
    });

    test('deleteEmployee returns true for 200 response', () async {
      when(() => mockClient.delete(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response('', 200));

      final result = await repository.deleteEmployee('abc');

      expect(result, isTrue);
    });
  });

  group('AuthBloc', () {
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      when(() => mockAuthRepository.authStateChanges).thenAnswer((_) => const Stream.empty());
    });

    test('emits AuthError when login fails with Firebase error', () async {
      when(
        () => mockAuthRepository.login(email: 'user@example.com', password: 'wrongpass'),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password', message: 'Invalid password'));

      final bloc = AuthBloc(authRepository: mockAuthRepository);

      expectLater(bloc.stream, emitsInOrder([isA<AuthLoading>(), isA<AuthError>()]));

      bloc.add(LoginRequested(email: 'user@example.com', password: 'wrongpass'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await bloc.close();
    });

    test('emits PasswordResetSent after forgot password succeeds', () async {
      when(() => mockAuthRepository.forgotPassword(email: 'user@example.com')).thenAnswer((_) async {});

      final bloc = AuthBloc(authRepository: mockAuthRepository);

      expectLater(bloc.stream, emitsInOrder([isA<AuthLoading>(), isA<PasswordResetSent>()]));

      bloc.add(ForgotPasswordRequested(email: 'user@example.com'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await bloc.close();
    });

    test('emits AuthError when Google sign in fails', () async {
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenThrow(FirebaseAuthException(code: 'account-exists-with-different-credential'));

      final bloc = AuthBloc(authRepository: mockAuthRepository);

      expectLater(bloc.stream, emitsInOrder([isA<AuthLoading>(), isA<AuthError>()]));

      bloc.add(GoogleSignInRequested());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await bloc.close();
    });
  });

  group('EmployeeDashboardBloc', () {
    setUp(() {
      GetIt.instance.reset();
      final employees = [
        GetAllEmployeesAttributeModel(
          id: '1',
          name: 'Alice',
          emailId: 'alice@example.com',
          mobile: '9999999999',
          country: 'India',
          state: 'Maharashtra',
          district: 'Mumbai',
        ),
      ];

      GetIt.instance.registerSingleton<GetAllEmployeesUseCase>(FakeGetAllEmployeesUseCase(employees: employees));
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    test('updates to loading and success state when employee list loads', () async {
      final bloc = EmployeeDashboardBloc();
      final employees = [
        GetAllEmployeesAttributeModel(
          id: '1',
          name: 'Alice',
          emailId: 'alice@example.com',
          mobile: '9999999999',
          country: 'India',
          state: 'Maharashtra',
          district: 'Mumbai',
        ),
      ];

      bloc.emit(EmployeeDashboardLoading());
      bloc.emit(EmployeeDashboardSuccess(employees: employees));

      expect(bloc.state, isA<EmployeeDashboardSuccess>());
      expect((bloc.state as EmployeeDashboardSuccess).employees, hasLength(1));
      await bloc.close();
    });

    test('updates to create loading and success state when a new employee is created', () async {
      final bloc = EmployeeDashboardBloc();
      final employee = GetAllEmployeesAttributeModel(
        id: '1',
        name: 'Alice',
        emailId: 'alice@example.com',
        mobile: '9999999999',
        country: 'India',
        state: 'Maharashtra',
        district: 'Mumbai',
      );

      bloc.emit(CreateEmployeeLoading());
      bloc.emit(CreateEmployeeSuccess(employee: employee));

      expect(bloc.state, isA<CreateEmployeeSuccess>());
      expect((bloc.state as CreateEmployeeSuccess).employee.name, 'Alice');
      await bloc.close();
    });
  });

  group('LoginScreen widget', () {
    late MockAuthRepository mockAuthRepository;
    late AuthBloc authBloc;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      when(() => mockAuthRepository.authStateChanges).thenAnswer((_) => const Stream.empty());
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() => authBloc.close());

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: authBloc,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows auth error in snackbar', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: authBloc,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      authBloc.emit(AuthError(message: 'Invalid email or password.'));
      await tester.pump();

      expect(find.text('Invalid email or password.'), findsOneWidget);
    });
  });

  group('EmployeeDashboardMobileView widget', () {
    final sampleEmployees = [
      GetAllEmployeesAttributeModel(
        id: '101',
        name: 'Alice Johnson',
        emailId: 'alice@example.com',
        mobile: '+1 5551112222',
        country: 'USA',
        state: 'California',
        district: 'San Francisco',
      ),
      GetAllEmployeesAttributeModel(
        id: '202',
        name: 'Bob Smith',
        emailId: 'bob@example.com',
        mobile: '+44 7700 900123',
        country: 'UK',
        state: 'England',
        district: 'London',
      ),
    ];

    testWidgets('filters employees by selected field with live API data', (tester) async {
      final bloc = EmployeeDashboardBloc();
      bloc.emit(EmployeeDashboardSuccess(employees: sampleEmployees));

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: const MaterialApp(home: EmployeeDashboardMobileView()),
        ),
      );

      await tester.enterText(find.byType(TextField).first, '202');
      await tester.pump();

      expect(find.text('Bob Smith'), findsOneWidget);
      expect(find.text('Alice Johnson'), findsNothing);
    });

    testWidgets('shows empty state when no employee matches search', (tester) async {
      final bloc = EmployeeDashboardBloc();
      bloc.emit(EmployeeDashboardSuccess(employees: sampleEmployees));

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: const MaterialApp(home: EmployeeDashboardMobileView()),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'no-match');
      await tester.pump();

      expect(find.text('No employees match your search'), findsOneWidget);
    });

    testWidgets('shows loading indicator during data fetch', (tester) async {
      final bloc = EmployeeDashboardBloc();
      bloc.emit(EmployeeDashboardLoading());

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: const MaterialApp(home: EmployeeDashboardMobileView()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows delete confirmation dialog for an employee', (tester) async {
      final bloc = EmployeeDashboardBloc();
      bloc.emit(EmployeeDashboardSuccess(employees: sampleEmployees));

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: const MaterialApp(home: EmployeeDashboardMobileView()),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      expect(find.text('Delete Employee'), findsOneWidget);
      expect(find.text('Are you sure you want to delete Alice Johnson?'), findsOneWidget);
      expect(find.text('Delete'), findsWidgets);
    });
  });
}
