import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sliet_broadcast/core/services/api.dart';
import 'package:sliet_broadcast/core/services/authenticationService.dart';
import 'package:sliet_broadcast/provider/bookmarkNoticeNotifier.dart';
import 'package:sliet_broadcast/provider/interestedNoticeNotifier.dart';
import 'package:sliet_broadcast/provider/privateNoticeNotifier.dart';
import 'package:sliet_broadcast/provider/publicNoticeNotifier.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [Provider.value(value: Api())];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticationService) =>
        AuthenticationService(api: api),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider(create: (_) => PublicNoticeNotifier()),
  ChangeNotifierProvider(create: (_) => PrivateNoticeNotifier()),
  ChangeNotifierProvider(create: (_) => BookmarkNoticeNotifier()),
  ChangeNotifierProvider(create: (_) => InterestedNoticeNotifier()),
];
