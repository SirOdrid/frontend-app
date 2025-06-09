import 'package:flutter/material.dart';
import 'package:frontend_app/services/CameraGalleryService.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';

Widget uploadImage (){
  return serviceButton("Subir Imagen", CameraGalleryService.new, Icons.upload);
}