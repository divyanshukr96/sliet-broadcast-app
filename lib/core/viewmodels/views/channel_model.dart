import 'package:flutter/material.dart';
import 'package:sliet_broadcast/core/models/channel.dart';
import 'package:sliet_broadcast/core/models/notice_list.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/services/channel_service.dart';
import 'package:sliet_broadcast/core/services/notice_service.dart';
import 'package:sliet_broadcast/core/viewmodels/base_model.dart';
import 'package:sliet_broadcast/core/viewmodels/notice_base_model.dart';

class ChannelModel extends BaseModel implements InterestBookmark {
  ChannelService _channelService;
  NoticeService _noticeService;

  ChannelType _channelType;

  Channel _channelDetails;

  ChannelModel({
    @required ChannelService channelService,
    NoticeService noticeService,
  })  : _channelService = channelService,
        _noticeService = noticeService;

  set channelType(ChannelType channelType) {
    setBusy();
    _channelType = channelType;
    setBusy(value: false);
  }

  Future<void> getAllChannel() async {
    setBusy();
    await _channelService.fetchChannel();
    setBusy(value: false);
  }

  bool get hasChannel => _channelService.hasChannel;

  List<Channel> get allChannels => _channelService.allChannel;

  Channel get channelDetails => _channelDetails;

  List<Notice> get channelNotices => _channelDetails.notices;

  List<Channel> get channels {
    switch (_channelType) {
      case ChannelType.Administration:
        return _channelService.allChannel
            .where((channel) => channel.isAdmin)
            .toList();
      case ChannelType.Department:
        return _channelService.allChannel.where((channel) {
          return channel.userType == "DEPARTMENT" && !channel.isAdmin;
        }).toList();
      case ChannelType.Society:
        return _channelService.allChannel.where((channel) {
          return channel.userType == "SOCIETY" && !channel.isAdmin;
        }).toList();
      case ChannelType.Other:
        return _channelService.allChannel.where((channel) {
          return channel.userType == "CHANNEL" && !channel.isAdmin;
        }).toList();
      case ChannelType.Following:
        return _channelService.allChannel
            .where((channel) => channel.following)
            .toList();
    }
    return _channelService.allChannel;
  }

  void getChannelDetails(String channelId) async {
    setBusy();
    try {
      _channelDetails = await _channelService.channelDetails(channelId);
    } catch (err) {
      print('ChannelModel getChannelDetails Error : $err');
    }
    setBusy(value: false);
  }

  @override
  Future<void> bookmark(Notice notice) async {
    setBusy();
    try {
      notice = await _noticeService.bookmark(notice, null);
      await _updateChannelDetails(notice);
    } catch (err) {
      print('ChannelModel bookmark : $err');
    }
    setBusy(value: false);
  }

  @override
  Future<void> interested(Notice notice) async {
    setBusy();
    try {
      notice = await _noticeService.interested(notice, null);
      await _updateChannelDetails(notice);
    } catch (err) {
      print('ChannelModel interested : $err');
    }
    setBusy(value: false);
  }

  Future<void> _updateChannelDetails(Notice notice) async {
    _channelDetails.notices = _channelDetails.notices.map((Notice V) {
      if (V.id == notice.id) {
        V = notice;
      }
      return V;
    }).toList();
    _noticeService.updateAllNoticeList(notice, null);
  }

  Future<void> followChannel(String id) async {
    setBusy();
    await _channelService.followChannel(id);
    setBusy(value: false);
  }

  @override
  Future<void> updateNotice(Notice notice) {
    // TODO: implement updateNotice
    return null;
  }
}
