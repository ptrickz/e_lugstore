import 'package:flutter/material.dart';

import '../widgets/navdrawer.dart';

class Background extends StatefulWidget {
  final bool? isStaff;
  final bool hasDrawer;
  final String pageTitle;
  final String assetImage;
  final IconData? icon;
  final Function()? appBarLeading;
  final Widget child;
  const Background({
    super.key,
    required this.pageTitle,
    required this.assetImage,
    this.icon,
    this.appBarLeading,
    required this.child,
    required this.hasDrawer,
    this.isStaff,
  });

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: widget.hasDrawer
            ? NavDrawer(
                isStaff: widget.isStaff,
              )
            : null,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: widget.hasDrawer ? true : false,
          leading: widget.hasDrawer
              ? null
              : IconButton(
                  onPressed: widget.appBarLeading,
                  icon: Icon(
                    widget.icon,
                    size: 30,
                  ),
                ),
          title: Text(
            widget.pageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 1.0,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.width / 2 - 125,
              width: 250,
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.assetImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: widget.child,
            )
          ],
        ));
  }
}
