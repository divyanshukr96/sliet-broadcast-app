import 'package:dio/dio.dart';
import 'package:sliet_broadcast/core/models/channel.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';

class ChannelService {
  final NoticeService _api;

  static String path = "/channel";

  ChannelService({NoticeService api}) : _api = api;

  List<Channel> _channels;

  List<Channel> get allChannel => _channels;

  bool get hasChannel => _channels != null && _channels.length != 0;

  Future<void> fetchChannel() async {
    try {
      _channels = await _getChannels();
    } catch (e) {
      print('ChannelService fetchChannel : $e');
    }
  }

  Future<List<Channel>> _getChannels() async {
    Response response = await _api.get(path: path);
    return List<Channel>.from(response.data.map((V) => Channel.fromJson(V)));
  }

  Future<void> followChannel(String id) async {
    try {
      Response response = await _api.post(path: '/channel/follow/$id');
      _channels = _channels.map((channel) {
        if (channel.id == id) {
          channel.following = response.data['following'];
        }
        return channel;
      }).toList();
    } catch (err) {
      print('ChannelService followChannel : $err');
    }
  }

  Future<Channel> channelDetails(String channelId) async {
    Response response = await _api.get(path: '/user/$channelId');
    return Channel.fromJson(response.data);
  }
}
