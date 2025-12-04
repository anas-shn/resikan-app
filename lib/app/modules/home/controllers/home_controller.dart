import 'package:get/get.dart';

class HomeController extends GetxController {
  final selectedCategory = 0.obs;

  final List<Map<String, String>> categories = [
    {'name': 'Carpet', 'image': 'images/carpet.png'},
    {'name': 'Toilet', 'image': 'images/toilet.png'},
    {'name': 'Floor', 'image': 'images/floor.png'},
    {'name': 'Window', 'image': 'images/window.png'},
    {'name': 'Garden', 'image': 'images/garden.png'},
    {'name': 'Office', 'image': 'images/office.png'},
    {'name': 'Clothes', 'image': 'images/clothes.png'},
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void selectCategory(int index) {
    selectedCategory.value = index;
  }
}
