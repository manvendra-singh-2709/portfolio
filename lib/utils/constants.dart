class Images {
  Images._();

  static const String _basePath = "assets/images/";

  static const String pf1 = "${_basePath}pf1.jpeg";
  static const String pf2 = "${_basePath}pf2.jpeg";
  static const String pf3 = "${_basePath}pf3.jpeg";

  static const String logo = "${_basePath}logo.png";
}

class Animations {
  Animations._();

  static const String _basePath = "assets/animations/";

  static const String xyzMovie = "${_basePath}Si_Pt.csv";
}

class IconFromImage {
  IconFromImage._();

  static const String _basePath = "assets/icons/";

  static const String flutter = "${_basePath}flutter.png";
  static const String github = "${_basePath}github.png";
  static const String instagram = "${_basePath}instagram.png";
  static const String linkedin = "${_basePath}linkedin.png";
  static const String gmail = "${_basePath}gmail.png";

  static const Map<String, String> links = {
    linkedin: "https://www.linkedin.com/in/manvendra-singh-08a233222/",
    instagram: "https://www.instagram.com/tangy_spaghetti/",
    github: "https://github.com/manvendra-singh-2709",
    gmail: "12a.manvendrasingh@gmail.com",
  };
}

class PDFs {
  PDFs._();

  static const String _basePath = "assets/assets/pdfs/";

  static const String cv = "${_basePath}cv.pdf";

  static const String cvUrl =
      "https://drive.google.com/file/d/1vB-UxXNLu3KyC117Ay8cxiI_3ccNlLro/view?usp=sharing";
}

class Texts {
  static const double letterSpacing = 0.5;
  static const double height = 1.3;

  String get manvendrasingh => "Manvendra Singh";
  String get blogs => "Blogs";
  String get resume => "Resume";
  String get projects => "Projects";
  String get current => "Research Scholar (Chemical Engineering) IIT Kanpur";
  String get about =>
      "I am a Research Scholar in the Chemical Engineering departmet of IIT Kanpur. I completed my Bachelors of Technology in Chemical Engineering from Malaviya National Insititute of Technology (MNIT) Jaipur in 2021 with a gold medal and a CGPA of 9.88. I have expertise in coding languages like Java, Flutter, Python, Javascript, and Julia. Apart from a research scholar I am a software developer too.";
}
