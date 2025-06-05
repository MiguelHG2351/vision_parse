import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static Future<Directory> _getHistoryDirectory() async {
    // Obtiene el directorio de documentos de la app
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    print('Directorio de documentos de la app: ${appDocDir.path}');
    // Crea (si no existe) una subcarpeta llamada “history_images”
    final Directory historyDir = Directory('${appDocDir.path}/history_images');
    if (!await historyDir.exists()) {
      await historyDir.create(recursive: true);
    }
    return historyDir;
  }

  static Future<File> movePickerFileToHistory(File pickedFile) async {
    final Directory historyDir = await _getHistoryDirectory();
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '');
    final String extension = pickedFile.path.split('.').last; // p.ej. “jpg” o “png”
    final String filename = 'img_$timestamp.$extension';

    // Copia el archivo (no lo muevas directamente)
    final File newFile = await pickedFile.copy('${historyDir.path}/$filename');
    return newFile;
  }

  static Future<List<FileSystemEntity>> loadHistoryFiles() async {
    final Directory historyDir = await _getHistoryDirectory();
    // Listado de todos los archivos (puede incluir subdirectorios si hubiesen)
    final List<FileSystemEntity> allEntities = historyDir.listSync();
    // Filtramos para quedarnos solo con archivos (no carpetas) y con extensión de imagen
    final List<FileSystemEntity> imageFiles = allEntities.where((entity) {
      if (entity is File) {
        final String ext = entity.path.split('.').last.toLowerCase();
        return ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(ext);
      }
      return false;
    }).toList();

    // Opcional: ordenarlos por fecha de creación (si quieres mostrar el más reciente arriba)
    imageFiles.sort((a, b) {
      final DateTime aTime = File(a.path).lastModifiedSync();
      final DateTime bTime = File(b.path).lastModifiedSync();
      return bTime.compareTo(aTime); // descendente: más reciente primero
    });

    return imageFiles;
  }

  static Future<void> _deleteImage(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error borrando la imagen: $e');
    }
  }
}