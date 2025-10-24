enum Flavor { dev, staging, prod }

class FlavorConfig {
  static Flavor? appFlavor;

  static String get name => appFlavor.toString().split('.').last;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'AI ChatBot DEV';
      case Flavor.staging:
        return 'AI ChatBot STAGING';
      case Flavor.prod:
      default:
        return 'AI ChatBot';
    }
  }

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return "https://api-dev.example.com";
      case Flavor.staging:
        return "https://api-staging.example.com";
      case Flavor.prod:
      default:
        return "https://api.example.com";
    }
  }
}
