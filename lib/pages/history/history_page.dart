import 'package:flutter/material.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/history.service.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/sqflite_db/model/history.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_video_app/utils/duration_string.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService historyService = getIt<HistoryService>();

  final Color _greyColor = Colors.grey[600];
  TextStyle get _textRichStyle =>
      Theme.of(context).textTheme.caption.copyWith(color: _greyColor);

  String _createTimeString(DateTime t) {
    var now = DateTime.now();
    if (t.year == now.year && t.month == now.month && t.day == now.day) {
      return '今天';
    } else {
      String day = t.day < 10 ? '0${t.day}' : '${t.day}';
      String hour = t.hour < 10 ? '0${t.hour}' : '${t.hour}';
      String minute = t.minute < 10 ? '0${t.minute}' : '${t.minute}';

      return '${t.year}-${t.month}-$day $hour:$minute';
    }
  }

  String _durationString(int seconds) {
    return durationString(Duration(seconds: seconds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AnimeLocalizations.of(context).historicalRecord),
      ),
      body: Center(
        child: FutureBuilder<List<History>>(
          future: historyService.historys,
          builder: (context, AsyncSnapshot<List<History>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snap.connectionState == ConnectionState.done) {
              if (snap.hasError) {
                return Center(child: Text('${snap.error}'));
              }
              List<History> historys = snap.data;
              print(historys.length);
              if (historys.isEmpty) {
                return Center(
                    child: Text(AnimeLocalizations.of(context).notData));
              }
              return ListView.builder(
                itemExtent: 110, // 每个子项的高度
                itemCount: historys.length,
                itemBuilder: (content, int index) {
                  var h = historys[index];
                  return Slidable(
                    key: ValueKey(h.id),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.2,
                    child: InkWell(
                      onTap: () {
                        router.pushNamed('/anime-detail/${h.animeId}');
                      },
                      child: Card(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              /// left image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: AspectRatio(
                                  aspectRatio: 5 / 5,
                                  child: Image.network(
                                    h.cover,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),

                              /// right
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(h.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${h.playCurrent.isEmpty ? "第0集" : h.playCurrent}'),
                                                TextSpan(text: '  '),
                                                TextSpan(
                                                    text: _durationString(
                                                        h.position)),
                                                TextSpan(text: ' / '),
                                                TextSpan(
                                                    text: _durationString(
                                                        h.duration))
                                              ],
                                            ),
                                            style: _textRichStyle,
                                          ),
                                        ],
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    _createTimeString(h.time)),
                                            TextSpan(text: ' '),
                                          ],
                                        ),
                                        style: _textRichStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: IconSlideAction(
                          caption: 'delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => historyService.delete(h),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
