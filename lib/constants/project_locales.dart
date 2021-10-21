class ProjectLocale {
  final String lanaguageCode, title, image;
  ProjectLocale({this.title, this.lanaguageCode, this.image});
}

List<ProjectLocale> projectLocales = [
  new ProjectLocale(
      title: 'English', lanaguageCode: 'en', image: 'assets/images/us.jpg'),
  new ProjectLocale(
      title: 'मराठी', lanaguageCode: 'mr', image: 'assets/images/india.png'),
];
