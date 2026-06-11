class AiAdvisorService {

  // Gelişmiş Kural Tabanlı Uzman Sistem 
  static String analyzeIssueAndRecommend(String issueDescription) {
    String lowerCaseIssue = issueDescription.toLowerCase();

    String diagnosis = "";
    String action = "";
    String estTime = "";
    int confidence = 0;

    //Kural: Zaman Tutma Hataları
    if (RegExp(r'(geri|ileri|sapma|saniye|hızlı|yavaş)').hasMatch(lowerCaseIssue)) {
      diagnosis = "Zaman Tutma Sapması (İzokronizm Hatası)";
      action = "Timegrapher ile anlık sapma, genlik (amplitude) ve vuruş hatası (beat error) ölçümü. Regülasyon (kalibrasyon) ve mikro-ayar.";
      estTime = "1-2 Gün";
      confidence = 92;
    }
    //Su/Nem Geçirme Krizleri
    else if (RegExp(r'(su|buğu|nem|ter|ıslak|pas)').hasMatch(lowerCaseIssue)) {
      diagnosis = "Kasa İçi Nem / Su Yalıtım İhlali";
      action = "ACİL MÜDAHALE! Kasa kapağının açılıp mekanizmanın kurutulması. O-ring contaların yenilenmesi ve 10 BAR kuru basınç testi.";
      estTime = "3-5 Gün";
      confidence = 98;
    }
    //Güç Aktarım ve Kurma Sorunları
    else if (RegExp(r'(duruyor|çalışmıyor|kurulmuyor|sert|kilitli|zemberek)').hasMatch(lowerCaseIssue)) {
      diagnosis = "Güç Aktarım (Kinematik) Arızası";
      action = "Zemberek (Mainspring) tork testi, otomatik kurma modülü (Magic Lever/Rotor) kontrolü ve sürtünme testi.";
      estTime = "7-10 Gün";
      confidence = 85;
    }
    //Fiziksel / Akustik Sorunlar
    else if (RegExp(r'(ses|sürtünme|tıkırtı|çizik|kırık|cam)').hasMatch(lowerCaseIssue)) {
      diagnosis = "Fiziksel/Kozmetik Hasar veya Rotor Sürtünmesi";
      action = "Rotor rulman kontrolü, Moebius yağları ile yeniden yağlama ve gerekirse safir/mineral cam değişimi.";
      estTime = "5-7 Gün";
      confidence = 88;
    }
    //Bilinmeyen veya Genel Durumlar
    else {
      diagnosis = "Bilinmeyen Mekanik Düzensizlik";
      action = "Mekanizmanın kasadan ayrılıp tam demontaj (Overhaul) ile mikroskobik incelemeye alınması.";
      estTime = "10-14 Gün";
      confidence = 65;
    }

    return "🔍 Kök Neden Tespiti: $diagnosis\n\n"
        "🛠️ Önerilen İşlem: $action\n\n"
        "⏱️ Tahmini Süre: $estTime\n\n"
        "📊 AI Güven Skoru: %$confidence";
  }
}