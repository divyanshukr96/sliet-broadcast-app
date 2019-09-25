import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:sliet_broadcast/style/theme.dart' as Theme;

class Profile extends StatelessWidget {
  final String _fullName = "ACSS Department";
  final String _username = "acss";
  final String _status = "Software Developer";
  final String _bio =
      "\"This is your department and it is very nice to give id's to people in the Institute. Plese dont come again and again to extend your ids.\"";
  final String _followers = "173";
  final String _posts = "24";
  final String _scores = "450";

/*  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
          fit: BoxFit.cover,

        ),
      ),
    );
  }*/

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "@" + _username,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _fullName,
            style: _nameTextStyle,
          ),
        ),
      ],
    );
  }

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

  Widget _buildStatContainer() {
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

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,
      //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: 16.0,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          child: Text(
            _bio,
            textAlign: TextAlign.center,
            style: bioTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.3,
      height: 2.0,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8, top: 4.0),
    );
  }

  Widget _buildNoticesText(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        color: Theme.Colors.loginGradientEnd,
        padding: EdgeInsets.all(8),
        child: Text(
          "Notices by ${_fullName.split(" ")[0]},",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Stack(
        children: <Widget>[
          //_buildCoverImage(screenSize),
          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    _buildProfileImage(),
                    _buildFullName(),
//                    _buildStatus(context),
//                    _buildStatContainer(),
                    _buildBio(context),
                    _buildSeparator(screenSize),
                    _buildNoticesText(context),
                    SizedBox(height: 8.0),
                    //_buildButtons(),
                    _buildNoticesByUser(),
                  ],
                ),
              ),
            ),
          ),
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
}
