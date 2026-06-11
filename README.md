# ChronoCare - Akıllı Saat Koleksiyon ve Servis Yönetim Sistemi

[![Flutter Version](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%E2%89%A53.0.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Database](https://img.shields.io/badge/SQLite-sqflite-003B57?logo=sqlite&logoColor=white)](https://pub.dev/packages/sqflite)
[![State Management](https://img.shields.io/badge/State-Provider-01579B?logo=dart&logoColor=white)](https://pub.dev/packages/provider)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg)](#)

ChronoCare, mekanik saat koleksiyonerlerinin envanterlerini uçtan uca yönetmesi, saat mekanizmalarının periyodik bakımlarını takip edebilmesi ve yapay zeka destekli otonom bir uzman sistem aracılığıyla olası mekanik arızaları teşhis edebilmesi amacıyla geliştirilmiş **üretim kalitesinde (production-ready)** bir Flutter mobil uygulamasıdır.

Bu proje, **İstanbul Topkapı Üniversitesi Bilgisayar Mühendisliği Mobil Uygulama Tasarımı ve Geliştirme** dersi final projesi gereksinimlerine ve katı yazılım mühendisliği kurallarına uygun olarak tasarlanmıştır.

---

## Katmanlı Mimari ve Klasör Yapısı (Layered Architecture)

Proje; bağımlılıkları minimuma indirmek, test edilebilirliği en üst düzeye çıkarmak ve sürdürülebilirliği artırmak adına kesin sınırlarla ayrılmış **3 Katmanlı Mimari (Presentation, Business, Data)** prensiplerine göre yapılandırılmıştır.

```text
lib/
├── data/                  # 1. VERİ KATMANI (DATA LAYER)
│   ├── database_helper/   # SQLite veritabanı kurulumu, tablo şemaları ve versiyon yönetimi
│   ├── models/            # Immutable (değiştirilemez) veri modelleri (Watch, ServiceTicket, User)
│   └── dao/               # Veritabanı doğrudan erişim sınıfları (WatchDao, ServiceDao, UserDao)
│
├── business/              # 2. İŞ MANTIĞI KATMANI (BUSINESS/DOMAIN LAYER)
│   ├── ai_advisor/        # Kural Tabanlı AI Arıza Teşhis Motoru (Uzman Sistem)
│   ├── state/             # Global durum yönetimi (AppProvider)
│   └── repositories/      # Veri kaynaklarını UI'dan soyutlayan köprü sınıfı (AppRepository)
│
└── ui/                    # 3. SUNUM KATMANI (PRESENTATION LAYER)
    ├── widgets/           # Tekrar kullanılabilir modüler bileşenler (WatchCard, StatPanel, vb.)
    └── screens/           # Uygulama ekranları (Dashboard, AddWatch, ServiceDetail, Login, vb.)
```

### Katman Sorumlulukları
*   **Data Layer (Veri Katmanı):** Çevrimdışı öncelikli (offline-first) mimari gereği SQLite üzerinden yerel veri saklama işlemlerini yönetir. İlişkisel tablolar arasında `ON DELETE CASCADE` kısıtlamaları kullanılarak veri bütünlüğü (referential integrity) korunur. Ham veri setlerini Dart nesnelerine (ve tersine) dönüştürür.
*   **Business Layer (İş Mantığı Katmanı):** Uygulamanın beynidir. Kural tabanlı yapay zeka analiz algoritmalarını ve merkezi durum yönetimini (State Management) barındırır. `AppRepository` katmanı veri tabanının karmaşık sorgularını UI katmanından tamamen gizler.
*   **Presentation Layer (Sunum Katmanı):** Kullanıcının etkileşime girdiği lüks ve akıcı (premium) arayüzdür. İş mantığı barındırmaz; yalnızca `Provider` üzerinden durum değişikliklerini dinleyerek arayüzü reaktif olarak günceller.

---

## Öne Çıkan Özellikler

*   **Güvenli Giriş & Kayıt Sistemi:** Kullanıcılar yerel SQLite veritabanında saklanan kimlik bilgileriyle güvenli bir şekilde hesap oluşturabilir, giriş yapabilir ve oturumlarını kalıcı hale getirebilirler.
*   **Dinamik Koleksiyon Takibi:** Seiko 4R35, Miyota 9039, Sellita SW200 veya ETA 2824 gibi farklı kalibrelere, markalara, kasa tiplerine ve satın alım detaylarına sahip saatler ayrıntılı bir şekilde envantere kaydedilebilir.
*   **AI Destekli Arıza Teşhis Motoru (Uzman Sistem):** Kullanıcı şikayetlerini ve `ImagePicker` aracılığıyla yüklenen saat fotoğraflarını analiz eden kural tabanlı uzman sistem (Regex & Karar Ağacı tabanlı); mekanik kök neden analizi, tahmini onarım süresi, yapay zeka güven skoru (%) ve kullanıcıya yönelik acil eylem planı üretir.
*   **Tam Kapsamlı Servis Geçmişi:** Saatlere ait oluşturulan arıza ve bakım biletleri (ticket) listelenebilir, anında güncellenebilir (Update) ve silinebilir (Delete).
*   **Analitik Kontrol Paneli (Dashboard):** Özel tasarlanmış göstergeler sayesinde koleksiyondaki toplam saat sayısı, servis sürecindeki aktif saatler ve yaklaşan bakım zamanları anlık olarak analiz edilir.
*   **Premium Amber/Antrasit Tema:** Geleneksel lüks saat markalarının prestijli vizyonundan ilham alınarak tasarlanan, koyu antrasit tonları ve amber (kehribar) detaylarına sahip göz yormayan premium tema yapısı.

---

## Kullanılan Teknolojiler ve Bağımlılıklar

*   **Flutter & Dart** - Mobil uygulama çatısı ve programlama dili.
*   **SQLite (sqflite)** - İlişkisel yerel veritabanı yönetimi (Foreign Key & Cascade desteği ile).
*   **Provider** - Reaktif UI, tema yönetimi ve temiz state yönetimi mimarisi.
*   **image_picker** - Cihaz kamerası ve yerel galeri ile görsel yükleme entegrasyonu.
*   **path_provider** - Cihaz dosya sistemi entegrasyonu ve güvenli SQLite yol tanımlaması.

---

## Kurulum ve Çalıştırma

Projeyi yerel bilgisayarınızda kurmak ve çalıştırmak için aşağıdaki adımları takip edin:

### Gereksinimler
*   Bilgisayarınızda güncel **Flutter SDK** yüklü olmalıdır. ([Kurulum Kılavuzu](https://docs.flutter.dev/get-started/install))
*   Android Studio / VS Code ve çalışır durumda bir Emülatör ya da fiziksel cihaz.

### Adımlar

1.  **Depoyu Klonlayın:**
    ```bash
    git clone https://github.com/basaranmirac/chronocare.git
    ```
2.  **Proje Dizinine Geçin:**
    ```bash
    cd chronocare
    ```
3.  **Gerekli Paketleri İndirin:**
    ```bash
    flutter pub get
    ```
4.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```

---

## Varsayılan Giriş Bilgileri

Uygulamayı ilk açtığınızda hızlıca test edebilmek için aşağıdaki önceden tanımlanmış test hesabını kullanabilir veya giriş ekranındaki kayıt ol seçeneğiyle kendi koleksiyoner profilinizi sıfırdan oluşturabilirsiniz:

*   **Kullanıcı Adı:** `admin`
*   **Şifre:** `12345`

---

## Lisans ve İletişim

Bu proje, eğitim amaçlı ve yazılım mimarisi en iyi pratiklerini (best practices) göstermek amacıyla geliştirilmiştir. 
Herhangi bir soru veya geri bildirim için GitHub üzerinden bir Issue açabilir ya da iletişime geçebilirsiniz.
```
