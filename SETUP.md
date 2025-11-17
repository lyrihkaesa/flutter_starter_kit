# TronPower Flutter App - Setup & Development Guide

## Architecture Overview

This project follows **Clean Architecture** principles with three main layers:

### 1. Presentation Layer (`lib/features/*/presentation/`)
- **BLoC Pattern**: State management using flutter_bloc
- **Pages**: UI screens
- **Widgets**: Reusable UI components

### 2. Domain Layer (`lib/features/*/domain/`)
- **Entities**: Pure business models
- **Repositories**: Abstract interfaces
- **Use Cases**: Business logic

### 3. Data Layer (`lib/features/*/data/`)
- **Models**: JSON serializable data models
- **Data Sources**: Remote (API) and Local (Database/Cache)
- **Repository Implementations**: Concrete implementations

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # Constants, enums, endpoints
│   ├── di/              # Dependency injection
│   ├── errors/          # Error handling
│   ├── network/         # API client & interceptors
│   ├── router/          # Navigation routing
│   ├── theme/           # App theming
│   └── utils/           # Utility functions
├── features/
│   ├── auth/            # Authentication feature
│   ├── energy/          # Energy rental feature
│   ├── transactions/    # Transaction history
│   └── affiliate/       # Affiliate system
└── main.dart
```

## Setup Instructions

### 1. Environment Configuration

Create a `.env` file in the root directory:

```env
API_BASE_URL=https://api.tronpower.io
API_TIMEOUT=30000
TRON_NETWORK=mainnet
TRON_GRID_API_KEY=your_api_key_here
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

Run code generation for models, freezed classes, and dependency injection:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App

```bash
flutter run
```

## Backend API Integration

### API Base URL

The app connects to your Node.js backend at the URL specified in `.env`:
- Default: `https://api.tronpower.io`

### Expected API Endpoints

#### Authentication
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/logout` - User logout
- `GET /user/profile` - Get current user

#### Energy Rental
- `GET /energy/packages` - Get energy packages
- `POST /energy/quick-buy` - Quick buy energy
- `POST /energy/rent` - Rent energy package
- `GET /energy/history` - Energy rental history
- `GET /energy/balance/:address` - Get energy balance

#### Transactions
- `GET /transactions` - Get transaction list
- `GET /transactions/:id` - Get transaction details

#### Affiliate
- `GET /affiliate/stats` - Get affiliate statistics
- `POST /affiliate/withdraw` - Withdraw earnings

### API Response Format

All API responses should follow this format:

```json
{
  "success": true,
  "data": {
    // Response data here
  },
  "message": "Success message"
}
```

Error responses:

```json
{
  "success": false,
  "error": "Error message",
  "message": "User-friendly error message"
}
```

### Authentication

The app uses JWT tokens for authentication:
- Access token stored in SharedPreferences
- Automatically added to requests via `AuthInterceptor`
- Token refresh handled automatically

## Extending the App

### Adding a New Feature

1. **Create Feature Structure**

```bash
mkdir -p lib/features/new_feature/{data,domain,presentation}
mkdir -p lib/features/new_feature/data/{models,datasources,repositories}
mkdir -p lib/features/new_feature/domain/{entities,repositories,usecases}
mkdir -p lib/features/new_feature/presentation/{bloc,pages,widgets}
```

2. **Create Entity** (`domain/entities/`)

```dart
import 'package:equatable/equatable.dart';

class MyEntity extends Equatable {
  final String id;
  final String name;

  const MyEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
```

3. **Create Repository Interface** (`domain/repositories/`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/my_entity.dart';

abstract class MyRepository {
  Future<Either<Failure, List<MyEntity>>> getAll();
  Future<Either<Failure, MyEntity>> getById(String id);
}
```

4. **Create Model** (`data/models/`)

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/my_entity.dart';

part 'my_model.g.dart';

@JsonSerializable()
class MyModel extends MyEntity {
  const MyModel({
    required super.id,
    required super.name,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);
}
```

5. **Create Data Source** (`data/datasources/`)

```dart
import '../../../../core/network/dio_client.dart';
import '../models/my_model.dart';

abstract class MyRemoteDataSource {
  Future<List<MyModel>> getAll();
}

class MyRemoteDataSourceImpl implements MyRemoteDataSource {
  final DioClient dioClient;

  MyRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<MyModel>> getAll() async {
    final response = await dioClient.get('/my-endpoint');
    return (response.data['data'] as List)
        .map((json) => MyModel.fromJson(json))
        .toList();
  }
}
```

6. **Implement Repository** (`data/repositories/`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/my_entity.dart';
import '../../domain/repositories/my_repository.dart';
import '../datasources/my_remote_datasource.dart';

class MyRepositoryImpl implements MyRepository {
  final MyRemoteDataSource remoteDataSource;

  MyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyEntity>>> getAll() async {
    try {
      final result = await remoteDataSource.getAll();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

7. **Create BLoC** (`presentation/bloc/`)

```dart
// my_event.dart
abstract class MyEvent extends Equatable {}

class LoadMyData extends MyEvent {
  @override
  List<Object?> get props => [];
}

// my_state.dart
abstract class MyState extends Equatable {}

class MyInitial extends MyState {
  @override
  List<Object?> get props => [];
}

class MyLoading extends MyState {
  @override
  List<Object?> get props => [];
}

class MyLoaded extends MyState {
  final List<MyEntity> data;

  MyLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

// my_bloc.dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final MyRepository repository;

  MyBloc({required this.repository}) : super(MyInitial()) {
    on<LoadMyData>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadMyData event,
    Emitter<MyState> emit,
  ) async {
    emit(MyLoading());

    final result = await repository.getAll();

    result.fold(
      (failure) => emit(MyError(failure.message)),
      (data) => emit(MyLoaded(data)),
    );
  }
}
```

8. **Register in DI** (`core/di/injection.dart`)

```dart
// Data Source
getIt.registerLazySingleton<MyRemoteDataSource>(
  () => MyRemoteDataSourceImpl(getIt<DioClient>()),
);

// Repository
getIt.registerLazySingleton<MyRepository>(
  () => MyRepositoryImpl(
    remoteDataSource: getIt<MyRemoteDataSource>(),
  ),
);

// BLoC
getIt.registerFactory(
  () => MyBloc(repository: getIt<MyRepository>()),
);
```

## Common Tasks

### Adding a New API Endpoint

1. Add endpoint constant in `lib/core/constants/app_constants.dart`:

```dart
class ApiEndpoints {
  static const String myNewEndpoint = '/my-endpoint';
}
```

2. Use in data source:

```dart
await dioClient.get(ApiEndpoints.myNewEndpoint);
```

### Adding New Theme Colors

Edit `lib/core/theme/app_colors.dart`:

```dart
static const Color myNewColor = Color(0xFFXXXXXX);
```

### Creating Reusable Widgets

Place in `lib/shared/widgets/`:

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

## Testing

### Running Tests

```bash
flutter test
```

### Integration Tests

```bash
flutter test integration_test
```

## Building for Production

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Troubleshooting

### Code Generation Issues

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dependency Conflicts

```bash
flutter pub upgrade --major-versions
```

### Clear Build Cache

```bash
flutter clean
flutter pub get
```

## Next Steps

1. **Implement remaining features**:
   - Transaction history with pagination
   - Energy calculator with real-time calculations
   - Affiliate dashboard with earnings tracking
   - Wallet integration with TRON blockchain
   - Push notifications for energy delivery
   - Biometric authentication

2. **Add comprehensive testing**:
   - Unit tests for use cases
   - Widget tests for UI components
   - Integration tests for flows

3. **Optimize performance**:
   - Implement proper caching strategy
   - Add image optimization
   - Lazy loading for lists

4. **Enhance UX**:
   - Add loading skeletons
   - Implement pull-to-refresh
   - Add haptic feedback
   - Improve error messages

## Support

For issues or questions:
- Email: support@tronpower.io
- Documentation: https://docs.tronpower.io
- API Docs: https://api.tronpower.io/docs
