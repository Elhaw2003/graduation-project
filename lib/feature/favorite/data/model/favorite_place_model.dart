class FavoritePlaceModel {
  final String title;
  final String description;
  final List<PlaceItemModel> places;

  const FavoritePlaceModel({
    required this.title,
    required this.description,
    required this.places,
  });
}

class PlaceItemModel {
  final String name;
  final String image;
  final bool isFavorite;

  const PlaceItemModel({
    required this.name,
    required this.image,
    required this.isFavorite,
  });
}

/// Temporary demo data until API/state is wired.
const List<FavoritePlaceModel> favoriteDemoSections = <FavoritePlaceModel>[
  FavoritePlaceModel(
    title: 'Cairo city',
    description:
        'The vibrant heart of Egypt and the city of a thousand minarets',
    places: <PlaceItemModel>[
      PlaceItemModel(
        name: 'The Great Pyramid &\nSphinx of Giza',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
      PlaceItemModel(
        name: 'Cairo Tower & The\nNile',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
      PlaceItemModel(
        name: 'Khan el-Khalili',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
    ],
  ),
  FavoritePlaceModel(
    title: 'Sharm El Sheikh city',
    description:
        'Egypt’s premier coastal destination for world-class resorts and crystal waters',
    places: <PlaceItemModel>[
      PlaceItemModel(
        name: 'Ras Mohammed\nNature Reserve',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: false,
      ),
      PlaceItemModel(
        name: 'El Fanar Beach',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: false,
      ),
      PlaceItemModel(
        name: 'SOHO Square',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
    ],
  ),
  FavoritePlaceModel(
    title: 'Luxor & Aswan Cities',
    description:
        'A journey through time to the cradle of ancient civilizations and the magic of the Nile',
    places: <PlaceItemModel>[
      PlaceItemModel(
        name: 'Karnak Temple\nComplex',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
      PlaceItemModel(
        name: 'Hatshepsut\nTemple',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
      PlaceItemModel(
        name: 'Philae Temple',
        image: 'assets/images/png/pyramids.jpg',
        isFavorite: true,
      ),
    ],
  ),
];
