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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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
    this.maxScale = 5.0,
    this.doubleTapScale = 2.0,
    @required this.child,
    this.onPressed,
  })  : assert(maxScale >= 1.0),
        assert(doubleTapScale >= 1.0 && doubleTapScale <= maxScale),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScaleAndDragDecoration();
  }
}

class _ScaleAndDragDecoration extends State<ScaleAndDragDecoration> with TickerProviderStateMixin {
  AnimationController _scaleAnimController;
  AnimationController _offsetAnimController;

  ScaleUpdateDetails _latestScaleUpdateDetails;

  double _scale = 1.0;
  Offset _offset = Offset.zero;

  Offset _doubleTapPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: _onPointerUp,
      child: GestureDetector(
        onTap: widget.onPressed,
        onDoubleTap: _onDoubleTap,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale, _scale),
          child: widget.child,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleAnimController?.dispose();
    _offsetAnimController?.dispose();
    super.dispose();
  }

  _onPointerUp(PointerUpEvent event) {
    _doubleTapPosition = event.localPosition;
  }

  _onDoubleTap() {
    double targetScale = _scale == 1.0 ? widget.doubleTapScale : 1.0;
    _animationScale(targetScale);
    if (targetScale == 1.0) {
      _animationOffset(Offset.zero);
    }
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
    if (_latestScaleUpdateDetails == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement = details.scale - _latestScaleUpdateDetails.scale;

    // 计算缩放比例
    _scale += scaleIncrement;
    if (_scale > widget.maxScale) {
      _scale = widget.maxScale;
    } else if (_scale < 0.5) {
      _scale = 0.5;
    }

    // 计算缩放后偏移前（缩放前后的内容中心对齐）的左上角坐标变化
    double scaleOffsetX = context.size.width * (_scale - 1.0) / 2;
    double scaleOffsetY = context.size.height * (_scale - 1.0) / 2;
    // 将缩放前的触摸点映射到缩放后的内容上
    double scalePointDX = (details.localFocalPoint.dx + scaleOffsetX - _offset.dx) / _scale;
    double scalePointDY = (details.localFocalPoint.dy + scaleOffsetY - _offset.dy) / _scale;
    // 计算偏移，使缩放中心在屏幕上的位置保持不变
    _offset += Offset(
      (context.size.width / 2 - scalePointDX) * scaleIncrement,
      (context.size.height / 2 - scalePointDY) * scaleIncrement,
    );

    _latestScaleUpdateDetails = details;
  }

  _dragging(ScaleUpdateDetails details) {
    if (_latestScaleUpdateDetails != null) {
      _offset += Offset(
        details.localFocalPoint.dx - _latestScaleUpdateDetails.localFocalPoint.dx,
        details.localFocalPoint.dy - _latestScaleUpdateDetails.localFocalPoint.dy,
      );
    }
    _latestScaleUpdateDetails = details;
  }

  _onScaleEnd(ScaleEndDetails details) {
    _latestScaleUpdateDetails = null;

    if (_scale < 1.0) {
      _animationScale(1.0);
    }
    if (_scale <= 1.0) {
      _animationOffset(Offset.zero);
    } else {
      double targetOffsetX = _offset.dx, targetOffsetY = _offset.dy;

      double scaleOffsetX = context.size.width * (_scale - 1.0) / 2;
      if (_offset.dx > scaleOffsetX) {
        targetOffsetX = scaleOffsetX;
      } else if (_offset.dx < -scaleOffsetX) {
        targetOffsetX = -scaleOffsetX;
      }

      if (context.size.height * _scale <= MediaQuery.of(context).size.height) {
        targetOffsetY = 0.0;
      } else {
        double scaleOffsetY = ((context.size.height * _scale) - MediaQuery.of(context).size.height) / 2;
        if (_offset.dy > scaleOffsetY) {
          targetOffsetY = scaleOffsetY;
        } else if (_offset.dy < -scaleOffsetY) {
          targetOffsetY = -scaleOffsetY;
        }
      }
      Offset targetOffset = Offset(targetOffsetX, targetOffsetY);
      if (_offset != targetOffset) {
        _animationOffset(targetOffset);
      }
    }
  }

  _animationScale(double targetScale) {
    _scaleAnimController?.dispose();
    _scaleAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    Animation anim = Tween<double>(begin: _scale, end: targetScale).animate(_scaleAnimController);
    anim.addListener(() {
      setState(() {
        _scaling(ScaleUpdateDetails(
          focalPoint: _doubleTapPosition,
          localFocalPoint: _doubleTapPosition,
          scale: anim.value,
          horizontalScale: anim.value,
          verticalScale: anim.value,
        ));
      });
    });
    anim.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onScaleEnd(ScaleEndDetails());
      }
    });
    _scaleAnimController.forward();
  }

  _animationOffset(Offset targetOffset) {
    _offsetAnimController?.dispose();
    _offsetAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    Animation anim =
        Tween<Offset>(begin: _offset, end: targetOffset).animate(_offsetAnimController);
    anim.addListener(() {
      setState(() {
        _offset = anim.value;
      });
    });
    _offsetAnimController.forward();
  }
}
