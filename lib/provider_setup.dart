import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/services/api.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/core/services/channel_service.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, previous) => AuthenticationService(api: api),
  ),
  ProxyProvider<Api, NoticeService>(
    update: (context, api, previous) => NoticeService(api: api),
  ),
  ProxyProvider<NoticeService, ChannelService>(
    update: (context, api, previous) => ChannelService(api: api),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  ),
];
