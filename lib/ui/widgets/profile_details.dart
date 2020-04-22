import 'package:flutter/material.dart';
import 'package:sliet_broadcast/core/models/user.dart';
import 'package:sliet_broadcast/ui/widgets/change_password.dart';
import 'package:sliet_broadcast/ui/screen/profile_edit_screen.dart';
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class ProfileDetails extends StatelessWidget {
  final User profile;

  ProfileDetails({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final String _status = "Software Developer";

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.Colors.loginGradientStart,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => print("followed"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "FOLLOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Message"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "MESSAGE",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatContainer() {
    final String _followers = "173";

    final String _posts = "24";

    final String _scores = "450";
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Posts", _posts),
          _buildStatItem("Scores", _scores),
        ],
      ),
    );
  }

  Widget _buildNoticesByUser() {
    return Container(
      color: Colors.white,
      height: 20,
      width: 100,
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        _buildFullName(),
//        _buildStatus(context),
//        _buildStatContainer(),
        _buildBio(context),
        _buildSeparator(screenSize),
        _buildNoticesText(context),
        SizedBox(height: 8.0),
//        _buildButtons(),
//        _buildNoticesByUser(),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: FlatButton(
              onPressed: () {
                Scaffold.of(context).showBottomSheet((builder) {
                  return ChangePassword();
                });
              },
              child: Text(
                "Change Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfileEditScreen(profile),
                  ),
                );
              },
              child: Text(
                "Edit Profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "@" + profile.username,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            profile.name,
            style: _nameTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w500,
      //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: 16.0,
    );

    if (profile.about.isEmpty) {
      return SizedBox(height: 0, width: 0);
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            profile.about,
            textAlign: TextAlign.justify,
            style: bioTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.3,
      height: 1.5,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4.0),
    );
  }

  Widget _buildNoticesText(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DetailField(title: "Email", value: profile.email),
              DetailField(title: "Mobile", value: profile.mobile),
              Divider(color: Colors.black38),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildUserDetails(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildUserDetails() {
    if (profile.userType == "FACULTY")
      return <Widget>[
        DetailField(title: "Department", value: profile.details.department),
        DetailField(title: 'Designation', value: profile.details.designation),
        DetailField(title: "D.O.B.", value: profile.details.dob),
      ];
    else if (profile.userType == "STUDENT")
      return <Widget>[
        DetailField(title: "Department", value: profile.details.department),
        DetailField(title: 'Program', value: profile.details.program),
        DetailField(title: 'Batch', value: profile.details.batch),
        DetailField(
          title: "Regd. No.",
          value: profile.details.registrationNumber,
        ),
        DetailField(title: "D.O.B.", value: profile.details.dob),
      ];
    else if (profile.userType == "SOCIETY")
      return <Widget>[
        DetailField(
            title: "Regd. No.", value: profile.details.registrationNumber),
        DetailField(
            title: 'Faculty Adviser', value: profile.details.facultyAdviser),
        DetailField(title: "Convener", value: profile.details.convener),
      ];
    else if (profile.userType == "DEPARTMENT" && !profile.isAdmin)
      return <Widget>[
        // TODO extraFields
//        DetailField(title: "H.O.D", value: profile.extraFields['hod']),
      ];
    return <Widget>[];
  }
}

class DetailField extends StatelessWidget {
  final String title;
  final dynamic value;

  DetailField({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        "$title:  " + value.toString(),
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}

class LoadingProfile extends StatelessWidget {
  const LoadingProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(height: 120),
        CircularProgressIndicator(backgroundColor: Colors.white54),
        SizedBox(height: 25),
        Text(
          'Loading profile . . .',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        )
      ],
    );
  }
}
