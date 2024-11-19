// import 'package:logger/logger.dart';
// import 'package:sero_office_employee_mobile/core/build_config.dart';
// import 'package:sero_office_employee_mobile/core/eventbus/event_bus.dart';

// import '../../domain/model/model_user.dart';
// import '../routes/app_routes.dart';
// import 'manager_route.dart';

// class ManagerUser {
// 	ManagerUser._internal();
// 	static final ManagerUser _instance = ManagerUser._internal();
// 	static ManagerUser get instance => _instance;

//   Logger get logger => BuildConfig.instance.logger;

//   ModelUser? _modelUser;

//   /// ManagerUser.instance.user 참조시 not null을 보장해야합니다.
//   ModelUser get user {
//     if(_modelUser == null) {

//       logger.e("ManagerUser: User is null");

//       ManagerRoute.instance.pushNamed(
//       	context: null,
//       	routes: Routes.LOGIN
//       );

//       final emptyModel = ModelUser(
//         userId: 0,
//         loginId: '',
//         userName: '',
//         picture: '',
//         isCredentialsNonExpired: false,
//         roles: [],
//       );
//       return emptyModel;
//     } else {
//       return _modelUser!;
//     }
//   }

//   /// 로그인 성공시 호출
//   cacheUserInfo({required ModelUser modelUser}) async {
//     logger.i("cacheUserInfo: ${modelUser.toJson()}");
//     _modelUser = modelUser;
//   }

//   logout() {
//     _modelUser = null;
//     EventBus.instance.clear();
//     ManagerRoute.instance.pushNamed(
//     	context: null,
//     	routes: Routes.LOGIN,
//       removeOthers: true
//     );
//   }

// }