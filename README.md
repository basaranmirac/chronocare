🕰️ ChronoCare (Akıllı Saat Koleksiyon ve Servis Yönetim Sistemi)
Bu proje, İstanbul Topkapı Üniversitesi Bilgisayar Mühendisliği Mobil Uygulama Tasarımı ve Geliştirme dersi final projesi gereksinimlerine ve katı yazılım mühendisliği kurallarına uygun olarak geliştirilmiş, üretim kalitesinde (production-ready) bir Flutter mobil uygulamasıdır.

Uygulama, mekanik saat koleksiyonerlerinin envanterlerini yönetmesini, saat mekanizmalarının periyodik bakımlarını takip edebilmesini ve yapay zeka destekli otonom bir uzman sistem aracılığıyla olası mekanik arızaları (izokronizm hataları, sıvı teması vb.) teşhis edebilmesini amaçlamaktadır.

🏗️ Katmanlı Mimari ve Klasör Yapısı (Layered Architecture)
Proje, bağımlılıkları minimuma indirmek, test edilebilirliği sağlamak ve sürdürülebilirliği artırmak adına kesin sınırlarla ayrılmış 3 Katmanlı Mimari (Presentation, Business, Data) yapısı üzerine kurulmuştur.

Plaintext
lib/
├── data/                  # 1. VERİ KATMANI (DATA LAYER)
│   ├── database_helper/   # SQLite veritabanı kurulumu ve tablo inşası
│   ├── models/            # Immutable veri modelleri (Watch, ServiceTicket, User)
│   └── dao/               # Veritabanı doğrudan erişim sınıfları (WatchDao, ServiceDao)
│
├── business/              # 2. İŞ MANTIĞI KATMANI (BUSINESS/DOMAIN LAYER)
│   ├── ai_advisor/        # Kural Tabanlı AI Arıza Teşhis Motoru (Uzman Sistem)
│   ├── state/             # State Yönetimi (AppProvider)
│   └── repositories/      # Veri kaynaklarını UI'dan soyutlayan köprü (AppRepository)
│
└── ui/                    # 3. SUNUM KATMANI (PRESENTATION LAYER)
    ├── widgets/           # Tekrar kullanılabilir arayüz elemanları (WatchCard, StatPanel)
    └── screens/           # Uygulama ekranları (Dashboard, AddWatch, ServiceDetail, Login)
Katman Sorumlulukları:
Data Layer (Veri Katmanı): Çevrimdışı (offline-first) kullanım için SQLite üzerinden tabloları yönetir. ON DELETE CASCADE kısıtlamalarıyla veri bütünlüğünü sağlar ve model nesnelerini (Map dönüşümleriyle) işler.

Business Layer (İş Mantığı Katmanı): Yapay zeka analiz algoritmalarını ve merkezi durum yönetimini (State Management) barındırır. AppRepository aracılığıyla veritabanı karmaşıklığını gizler.

Presentation Layer (Sunum Katmanı): Kullanıcının etkileşime girdiği lüks (premium) arayüzdür. İş mantığı barındırmaz, Provider üzerinden durum değişikliklerini dinleyerek anlık güncellenir.

✨ Öne Çıkan Özellikler
🔒 Modern Giriş & Kayıt Sistemi: Kullanıcılar hesap oluşturabilir ve yerel SQLite veritabanında saklanan verileriyle güvenli, kalıcı oturum açabilir.

⌚ Dinamik Koleksiyon Takibi: Kullanıcılar Seiko 4R35, Miyota 9039, Sellita SW200 gibi farklı kalibre ve markalara sahip saatlerini detaylı envanter listesinde takip edebilir.

🤖 Yapay Zeka Arıza Tespiti: Kullanıcı şikayetlerini ve ImagePicker ile yüklenen saat fotoğraflarını analiz eden Kural Tabanlı Uzman Sistem (Regex tabanlı); kök neden analizi, tahmini onarım süresi ve yapay zeka güven skoru (%) üretir. Tıbbi görüntüleme hassasiyetinden ilham alınarak geliştirilmiş bir analiz altyapısı mevcuttur.

🛠️ Tam Kapsamlı Servis Geçmişi: Saatlere ait oluşturulan arıza biletleri (ticket) listelenebilir, anında düzenlenebilir (Update) ve silinebilir (Delete).

📊 Analitik Dashboard: Özel tasarlanmış istatistik kartları sayesinde koleksiyondaki toplam saat sayısı ve aktif olarak "Bekleyen Servis" durumundaki cihazlar anlık takip edilebilir.

🌙 Premium Aydınlık / Karanlık Tema: Geleneksel lüks saat markalarının vizyonuna uygun, antrasit ve amber renk paletlerine sahip tema mimarisi ile göz yormayan bir deneyim sunulur.

🛠️ Kullanılan Teknolojiler ve Bağımlılıklar
Flutter & Dart

SQLite (sqflite): İlişkisel yerel veritabanı (Çapraz tablo ilişkileri ve FOREIGN KEY destekli).

Provider: İş mantığı, tema geçişleri ve arayüz durum yönetimi (State Management).

image_picker: Cihaz kamerası ve yerel galeri entegrasyonu.

path_provider: Veritabanı ve yerel dosya yönetimi dizinlemesi.

🚀 Kurulum ve Çalıştırma
Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edin:

Gereksinimler
Bilgisayarınızda Flutter SDK yüklü olmalıdır.

Android Studio / VS Code ve çalışır durumda bir emülatör.

Adımlar
Depoyu bilgisayarınıza klonlayın:

Bash
git clone https://github.com/basaranmirac/chronocare.git
Proje ana dizinine gidin:

Bash
cd chronocare
Gerekli paketleri indirin:

Bash
flutter pub get
Uygulamayı bir emülatörde veya gerçek cihazda çalıştırın:

Bash
flutter run
🔑 Varsayılan Giriş Bilgileri
Uygulamayı ilk açtığınızda test etmek için aşağıdaki varsayılan hesabı kullanabilir veya giriş ekranından anında kendi koleksiyoner profilinizi oluşturabilirsiniz:

Kullanıcı Adı: admin

Şifre: 12345
