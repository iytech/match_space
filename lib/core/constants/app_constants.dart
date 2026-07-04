/// App-wide constants: enums, table names, storage buckets, option lists.
class Tables {
  Tables._();
  static const profiles = 'profiles';
  static const properties = 'properties';
  static const propertyMedia = 'property_media';
  static const messages = 'messages';
  static const conversations = 'conversations';
  static const bookings = 'viewing_bookings';
  static const reviews = 'reviews';
  static const recentlyViewed = 'recently_viewed';
  static const subscriptions = 'subscriptions';
  static const favorites = 'favorites';
}

class Buckets {
  Buckets._();
  static const propertyMedia = 'property-media';
  static const avatars = 'avatars';
}

enum PropertyStatus { pending, approved, rejected }

enum PropertyType { house, apartment, duplex, bungalow, land, commercial, shortlet }

enum ListingPurpose { sale, rent }

enum UserRole { user, owner, admin }

enum BookingStatus { requested, confirmed, declined, completed }

enum SubscriptionTier { free, premium }

class AppOptions {
  AppOptions._();
  static const states = [
    'Plateau', 'Lagos', 'FCT Abuja', 'Rivers', 'Kano', 'Oyo', 'Kaduna',
    'Enugu', 'Delta', 'Edo', 'Anambra', 'Ogun', 'Cross River', 'Other',
  ];
  static const propertyTypeLabels = {
    PropertyType.house: 'House',
    PropertyType.apartment: 'Apartment',
    PropertyType.duplex: 'Duplex',
    PropertyType.bungalow: 'Bungalow',
    PropertyType.land: 'Land',
    PropertyType.commercial: 'Commercial',
    PropertyType.shortlet: 'Short-let',
  };
  static const amenities = [
    'Borehole', '24/7 Power', 'Security', 'Parking', 'Air Conditioning',
    'Furnished', 'POP Ceiling', 'En-suite', 'Fenced', 'Gated Estate',
    'Water Heater', 'CCTV', 'Swimming Pool', 'Generator',
  ];
}
