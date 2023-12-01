class IntroHelper {
  getImage(int i) {
    return 'assets/images/intro${i + 1}.png';
  }

  geTitle(int i) {
    List title = [
      "Showcase Professionally",
      "Program for Skill Enhancement",
      "Global Networking Connection"
    ];
    return title[i];
  }

  geSubTitle(int i) {
    List subTitle = [
      "Join our platform to create a professional profile showcasing your skills and expertise",
      "Join our program to boost and refine your skills, advancing your professional capabilities",
      "Expand your connections globally and engage with a diverse network worldwide"
    ];
    return subTitle[i];
  }
}
