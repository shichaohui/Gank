import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/widget/base_staggered_grid_view.dart';

/// 福利页面
class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfarePageState();
  }
}

class _WelfarePageState extends State<WelfarePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: BaseStaggeredGridView<Gank>(
        pageRequest: (page, pageSize) async {
          Welfare welfare = await API().getWelfare(page, pageSize);
          return welfare.result;
        },
        crossAxisCount: 2,
        itemBuilder: (context, index, gank) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _createBigImage(gank.url)),
              );
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Hero(
                  tag: gank.url,
                  child: CachedNetworkImage(
                    imageUrl: gank.url,
                    placeholder: (context, url) => Icon(Icons.image),
                    errorWidget: (context, url, error) => Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      leading: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).primaryTextTheme.title.color,
        ),
      ),
      title: Text("福利"),
      centerTitle: true,
    );
  }

  Widget _createBigImage(String url) {
    // 构建 PageView
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black),
      child: Hero(
        tag: url,
        child: ScaleAndDragDecoration(
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => Icon(Icons.image),
            errorWidget: (context, url, error) => Icon(Icons.broken_image),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class ScaleAndDragDecoration extends StatefulWidget {
  final double maxScale;
  final double doubleTapScale;
  final Widget child;
  final VoidCallback onPressed;

  const ScaleAndDragDecoration({
    Key key,
    this.maxScale = 3.0,
    this.doubleTapScale = 2.0,
    @required this.child,
    this.onPressed,
  })  : assert(maxScale >= 1),
        assert(doubleTapScale >= 1 && doubleTapScale <= maxScale),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScaleAndDragDecoration();
  }
}

class _ScaleAndDragDecoration extends State<ScaleAndDragDecoration> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  ScaleUpdateDetails _latestScaleUpdateDetails;

  double _scale = 1.0;
  Point _centerPoint;

  Alignment _scaleAlignment = Alignment(0, 0);
  Alignment _doubleTapAlignment = Alignment(0, 0);

  Offset _translateOffset = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    _calcCenterPoint(context);
    return Listener(
      onPointerUp: _onPointerUp,
      child: GestureDetector(
        onTap: widget.onPressed,
        onDoubleTap: _onDoubleTap,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        child: Transform.translate(
          offset: _translateOffset,
          child: Transform.scale(
            scale: _scale,
            child: widget.child,
            alignment: _scaleAlignment,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onPointerUp(PointerUpEvent event) {
    _doubleTapAlignment = _calcAlignment(event.localPosition);
  }

  _onDoubleTap() {
    _scaleAlignment = _doubleTapAlignment;
    double newScale = _scale == 1 ? widget.doubleTapScale : 1;
    _scaleAnimation = Tween<double>(begin: _scale, end: newScale).animate(_controller);
    _scaleAnimation.addListener(() => setState(() => _scale = _scaleAnimation.value));
    _controller.reset();
    _controller.forward();
  }

  _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (details.scale != 1.0) {
        _scaling(details);
      } else {
        _dragging(details);
      }
    });
  }

  _scaling(ScaleUpdateDetails details) {
    _scaleAlignment = _calcAlignment(details.localFocalPoint);
    if (_latestScaleUpdateDetails != null) {
      _scale += details.scale - _latestScaleUpdateDetails.scale;
      if (_scale > widget.maxScale) {
        _scale = widget.maxScale;
      } else if (_scale < 0.5) {
        _scale = 0.5;
      }
    }
    _latestScaleUpdateDetails = details;
  }

  _dragging(ScaleUpdateDetails details) {
    if (_latestScaleUpdateDetails != null) {
      double x = details.focalPoint.dx - _latestScaleUpdateDetails.focalPoint.dx + _translateOffset.dx;
      double y = details.focalPoint.dy - _latestScaleUpdateDetails.focalPoint.dy + _translateOffset.dy;
      _translateOffset = Offset(x, y);
    }
    _latestScaleUpdateDetails = details;
  }

  _onScaleEnd(ScaleEndDetails details) {
    _latestScaleUpdateDetails = null;
  }

  Alignment _calcAlignment(Offset position) {
    return Alignment(
      (position.dx - _centerPoint.x) / _centerPoint.x,
      (position.dy - _centerPoint.y) / _centerPoint.y,
    );
  }

  void _calcCenterPoint(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _centerPoint = Point(size.width / 2, size.height / 2);
  }
}
