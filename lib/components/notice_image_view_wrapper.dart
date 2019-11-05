import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NoticePhotoViewWrapper extends StatelessWidget {
  NoticePhotoViewWrapper({
    @required this.noticeImages,
    this.noticeTitle,
  });

  final dynamic noticeImages;
  final String noticeTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              PhotoViewGallery.builder(
                itemCount: noticeImages.length,
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                usePageViewWrapper: true,
                onPageChanged: (jj) {},
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(noticeImages[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained * 0.5,
                    maxScale: PhotoViewComputedScale.covered * 3,
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: noticeImages[index]),
                  );
                },
                loadingChild: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  noticeTitle,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
