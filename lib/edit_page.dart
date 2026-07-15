import 'package:flutter/material.dart';
import 'memo.dart';

class EditPage extends StatefulWidget {
  final Memo? memo;

  const EditPage({super.key, this.memo});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.memo?.title ?? '');

    contentController =
        TextEditingController(text: widget.memo?.content ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveMemo() {

    // タイトル必須
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("タイトルを入力してください"),
        ),
      );
      return;
    }

    final memo = Memo(
      title: titleController.text.trim(),
      content: contentController.text.trim(),

      // 新規なら現在時刻
      createdAt: widget.memo?.createdAt,

      // 更新日時は常に現在
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, memo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo == null ? "新規メモ" : "メモ編集"),
        actions: [

          if (widget.memo != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {

                Navigator.pop(context, "delete");

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
              decoration: const InputDecoration(
                labelText: "タイトル",
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: "本文",
                  alignLabelWithHint: true,
                ),
                expands: true,
                maxLines: null,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveMemo,
                child: const Text("保存"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}