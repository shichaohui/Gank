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
    this.maxScale = 5.0,
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
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
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
    _controller.dispose();
    super.dispose();
  }

  _onPointerUp(PointerUpEvent event) {}

  _onDoubleTap() {
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
    if (_latestScaleUpdateDetails == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement = details.scale - _latestScaleUpdateDetails.scale;

    if (_scale < 1) {
      // 以内容中心点作为缩放中心
      _offset = Offset.zero;
    } else {
      // 计算缩放后偏移前（缩放前后的内容中心对齐）的左上角坐标变化
      double scaleOffsetX = context.size.width * (_scale - 1) / 2;
      double scaleOffsetY = context.size.height * (_scale - 1) / 2;
      // 将缩放前的触摸点映射到缩放后的内容上
      double scalePointDX = (details.localFocalPoint.dx + scaleOffsetX - _offset.dx) / _scale;
      double scalePointDY = (details.localFocalPoint.dy + scaleOffsetY - _offset.dy) / _scale;
      // 计算偏移，使缩放中心在屏幕上的位置保持不变
      _offset += Offset(
        (context.size.width / 2 - scalePointDX) * scaleIncrement,
        (context.size.height / 2 - scalePointDY) * scaleIncrement,
      );
    }

    // 计算缩放比例
    _scale += scaleIncrement;
    if (_scale > widget.maxScale) {
      _scale = widget.maxScale;
    } else if (_scale < 0.5) {
      _scale = 0.5;
    }

    _latestScaleUpdateDetails = details;
  }

  _dragging(ScaleUpdateDetails details) {
    if (_latestScaleUpdateDetails != null) {
      _offset += Offset(
        details.focalPoint.dx - _latestScaleUpdateDetails.focalPoint.dx,
        details.focalPoint.dy - _latestScaleUpdateDetails.focalPoint.dy,
      );
    }
    _latestScaleUpdateDetails = details;
  }

  _onScaleEnd(ScaleEndDetails details) {
    _latestScaleUpdateDetails = null;
  }
}
