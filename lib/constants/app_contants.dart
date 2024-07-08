
// App Constants are are store Dummy Constants 
// Example : app name, about us, app languages

import '../models/category_model.dart';

class AppContants {

  static final List<CategoryModel> mCategories = [

    CategoryModel(catId: 12, catTitle: "Travel", catImgPath: ImagesContants.IMG_PATH_TRAVEL, ),
    CategoryModel(catId: 1, catTitle: "Cofee", catImgPath: ImagesContants.IMG_PATH_COFFEE, ),
    CategoryModel(catId: 2, catTitle: "Recharge", catImgPath: ImagesContants.IMG_PATH_RECHARGE, ),
    CategoryModel(catId: 3, catTitle: "Groceries", catImgPath: ImagesContants.IMG_PATH_GROCERIES, ),
    CategoryModel(catId: 4, catTitle: "Movie", catImgPath: ImagesContants.IMG_PATH_MOVIE, ),
    CategoryModel(catId: 5, catTitle: "Restaurant", catImgPath: ImagesContants.IMG_PATH_RESTAURANT, ),
    CategoryModel(catId: 6, catTitle: "Rent", catImgPath: ImagesContants.IMG_PATH_RENT, ),
    CategoryModel(catId: 7, catTitle: "Petrol", catImgPath: ImagesContants.IMG_PATH_PETROL, ),
    CategoryModel(catId: 8, catTitle: "Snacks", catImgPath: ImagesContants.IMG_PATH_SNACKS, ),
    CategoryModel(catId: 9, catTitle: "Shoppng", catImgPath: ImagesContants.IMG_PATH_SHOPPING, ),
    CategoryModel(catId: 10, catTitle: "Salon", catImgPath: ImagesContants.IMG_PATH_SALON, ),
    CategoryModel(catId: 11, catTitle: "Medicine", catImgPath: ImagesContants.IMG_PATH_MEDICINE, ),

  ];  // end list
}



class ImagesContants {

  static const String BASE_IMG_URL = "assets/icons/cat/";

  static const String IMG_PATH_COFFEE = "${BASE_IMG_URL}coffee.png";
  static const String IMG_PATH_GROCERIES = "${BASE_IMG_URL}grocery.png";
  static const String IMG_PATH_MEDICINE = "assets/icons/cat/medicine.png";
  static const String IMG_PATH_MOVIE = "assets/icons/cat/movie.png";
  static const String IMG_PATH_PETROL = "assets/icons/cat/petrol.png";
  static const String IMG_PATH_RECHARGE = "assets/icons/cat/recharge.png";
  static const String IMG_PATH_RENT = "assets/icons/cat/rent.png";
  static const String IMG_PATH_RESTAURANT = "assets/icons/cat/restaurant.png";
  static const String IMG_PATH_SALON = "assets/icons/cat/salon.png";
  static const String IMG_PATH_SHOPPING = "assets/icons/cat/shopping.png";
  static const String IMG_PATH_SNACKS = "assets/icons/cat/snack.png";
  static const String IMG_PATH_TRAVEL = "assets/icons/cat/travel.png";



}