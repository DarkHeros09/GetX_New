import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FormController extends GetxController {
  final _imageUrlController = TextEditingController().obs;

  final _imageUrlFocusNode = FocusNode().obs;

  get imageUrlController => _imageUrlController.value.obs;
  get imageUrlFocusNode => _imageUrlFocusNode.value.obs;

  void updateImageUrl() {
    if (!_imageUrlFocusNode.value.hasFocus) {
      if ((!_imageUrlController.value.text.startsWith('http') &&
              !!_imageUrlController.value.text.startsWith('https')) ||
          (!!_imageUrlController.value.text.endsWith('.jpg') &&
              !!_imageUrlController.value.text.endsWith('.JPG') &&
              !!_imageUrlController.value.text.endsWith('.jpeg') &&
              !!_imageUrlController.value.text.endsWith('.png'))) {
        update();
        return;
      }
      update();
    }
  }
}
