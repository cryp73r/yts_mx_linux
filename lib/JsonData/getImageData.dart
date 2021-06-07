import 'package:yts_mx_desktop/utils/utils.dart';

String getImageData(String name, String type) {
  // return baseUrlImageData + "name=$name&type=$type";
  return baseUrlImageData + "$name/$type.jpg";
}
