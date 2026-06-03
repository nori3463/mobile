import 'package:flutter/material.dart';
import 'memo.dart';

class EditPage extends StatefulWidget {
  final Memo? memo;

  EditPage({this.memo});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.memo?.title ?? '');
    contentController = TextEditingController(text: widget.memo?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo == null ? '新規メモ' : 'メモ編集'),
        actions: [
          if (widget.memo != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'タイトル'),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: '本文'),
                maxLines: null,
                expands: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final memo = Memo(
                  
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.pop(context, memo);
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
