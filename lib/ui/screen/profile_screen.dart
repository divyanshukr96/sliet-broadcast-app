import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliet_broadcast/core/constant.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/core/viewmodels/views/user_profile_model.dart';
import 'package:sliet_broadcast/ui/widgets/profile_details.dart';
import 'package:sliet_broadcast/views/base_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  Widget _buildProfileImage(User profile) {
    ImageProvider profileUrl = AssetImage('assets/images/login.png');
    if (profile.profile != null) profileUrl = NetworkImage(profile.profile);

    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: profileUrl,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: UserProfileModel(authenticationService: Provider.of(context)),
      onModelReady: (UserProfileModel model) => model.getUser(),
      builder: (context, UserProfileModel model, _) {
        return Scaffold(
          appBar: AppBar(title: Text("Profile")),
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(gradient: LoginLinearGradient()),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: StreamBuilder<User>(
                      stream: model.user,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 20),
                              _buildProfileImage(snapshot.data),
                              ProfileDetails(profile: snapshot.data),
                            ],
                          );
                        }
                        return LoadingProfile();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
