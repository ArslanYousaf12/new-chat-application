import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.onPickedImage});

  void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _newPickedImage;

  void _imagePicker() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 150, imageQuality: 50);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _newPickedImage = File(pickedImage.path);
    });
    widget.onPickedImage(_newPickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 45,
          foregroundImage:
              _newPickedImage != null ? FileImage(_newPickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _imagePicker,
          icon: const Icon(Icons.image),
          label: Text(
            'Take Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
