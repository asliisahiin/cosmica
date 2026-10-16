import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cosmica/services/tarot_service.dart';
import 'package:share_plus/share_plus.dart';

class TarotCard {
  final String name;
  final String suit;
  final String meaning;
  final String energy;

  const TarotCard({
    required this.name,
    required this.suit,
    required this.meaning,
    required this.energy,
  });
}

const List<TarotCard> tarotCards = [
  // =========================
  // BÜYÜK ARKANA
  // =========================

  TarotCard(
    name: 'Deli',
    suit: 'Büyük Arkana',
    meaning: 'Yeni başlangıçlar, özgürlük, cesaret ve bilinmeyene adım atmak.',
    energy: 'Yeni bir sayfanın açılması ve geçmişin yükünü geride bırakma.',
  ),
  TarotCard(
    name: 'Büyücü',
    suit: 'Büyük Arkana',
    meaning: 'İrade, yetenek, iletişim ve sahip olduğun imkanları kullanmak.',
    energy: 'Bir şeyi başlatmak için düşündüğünden daha fazla güce sahip olma.',
  ),
  TarotCard(
    name: 'Başrahibe',
    suit: 'Büyük Arkana',
    meaning: 'Sezgi, gizli bilgiler, iç ses ve henüz ortaya çıkmamış gerçekler.',
    energy: 'Her şeyin şu anda görünür olmadığı ve sezgilerine kulak vermen gereken bir dönem.',
  ),
  TarotCard(
    name: 'İmparatoriçe',
    suit: 'Büyük Arkana',
    meaning: 'Bereket, sevgi, yaratıcılık, şefkat ve büyüme.',
    energy: 'Bir ilişkinin, fikrin veya hayatındaki bir alanın gelişmeye başlaması.',
  ),
  TarotCard(
    name: 'İmparator',
    suit: 'Büyük Arkana',
    meaning: 'Düzen, güven, sınırlar, sorumluluk ve kontrol.',
    energy: 'Hayatında daha sağlam bir yapı kurma ihtiyacı.',
  ),
  TarotCard(
    name: 'Aziz',
    suit: 'Büyük Arkana',
    meaning: 'Gelenek, değerler, öğrenme, rehberlik ve inançlar.',
    energy: 'Bir konuda deneyimli birinden destek alma veya kendi doğrularını sorgulama.',
  ),
  TarotCard(
    name: 'Aşıklar',
    suit: 'Büyük Arkana',
    meaning: 'Bağlantı, çekim, uyum ve önemli bir seçim.',
    energy: 'Kalbinle aklın arasında kalabileceğin veya bir bağın önem kazanabileceği bir dönem.',
  ),
  TarotCard(
    name: 'Savaş Arabası',
    suit: 'Büyük Arkana',
    meaning: 'Kararlılık, hareket, mücadele ve hedefe ilerlemek.',
    energy: 'Kontrolü eline alıp istediğin yöne doğru ilerleme.',
  ),
  TarotCard(
    name: 'Güç',
    suit: 'Büyük Arkana',
    meaning: 'Cesaret, sabır, öz kontrol ve duygularını yönetebilmek.',
    energy: 'Zorlayıcı bir durumda sertleşmek yerine sakin kalmanın gücü.',
  ),
  TarotCard(
    name: 'Ermiş',
    suit: 'Büyük Arkana',
    meaning: 'İçe dönüş, yalnız kalma, düşünme ve kendi cevabını bulma.',
    energy: 'Dışarıdan cevap aramak yerine kendini dinleme ihtiyacı.',
  ),
  TarotCard(
    name: 'Kader Çarkı',
    suit: 'Büyük Arkana',
    meaning: 'Değişim, döngüler, beklenmedik gelişmeler ve dönüm noktaları.',
    energy: 'Kontrol edemediğin bir değişimin yeni bir kapı açması.',
  ),
  TarotCard(
    name: 'Adalet',
    suit: 'Büyük Arkana',
    meaning: 'Denge, dürüstlük, sorumluluk ve sonuçlarla yüzleşmek.',
    energy: 'Bir konuda gerçeklerin daha görünür hale gelmesi.',
  ),
  TarotCard(
    name: 'Asılan Adam',
    suit: 'Büyük Arkana',
    meaning: 'Beklemek, teslimiyet, bakış açısını değiştirmek ve akışa bırakmak.',
    energy: 'İlerlemek için önce bir şeyi farklı açıdan görme gereği.',
  ),
  TarotCard(
    name: 'Ölüm',
    suit: 'Büyük Arkana',
    meaning: 'Bitiş, dönüşüm, eski bir dönemi kapatmak ve yenilenmek.',
    energy: 'Bir şeyin sona ermesiyle başka bir dönemin başlayabilmesi.',
  ),
  TarotCard(
    name: 'Denge',
    suit: 'Büyük Arkana',
    meaning: 'Uyum, sabır, ölçülülük ve iki farklı enerjiyi birleştirmek.',
    energy: 'Aşırılıklardan uzaklaşıp daha sakin bir noktaya gelmek.',
  ),
  TarotCard(
    name: 'Şeytan',
    suit: 'Büyük Arkana',
    meaning: 'Bağımlılık, yoğun arzu, takıntı ve kişinin kendini sınırlaması.',
    energy: 'Seni özgürleştirmek yerine sana bağlı tutan bir döngüyü fark etmek.',
  ),
  TarotCard(
    name: 'Kule',
    suit: 'Büyük Arkana',
    meaning: 'Ani değişim, şaşırtıcı gerçekler ve eski yapıların yıkılması.',
    energy: 'Beklenmedik bir farkındalığın olaylara bakışını değiştirmesi.',
  ),
  TarotCard(
    name: 'Yıldız',
    suit: 'Büyük Arkana',
    meaning: 'Umut, iyileşme, ilham ve geleceğe yeniden güvenmek.',
    energy: 'Zor bir dönemden sonra içinin yeniden hafiflemesi.',
  ),
  TarotCard(
    name: 'Ay',
    suit: 'Büyük Arkana',
    meaning: 'Belirsizlik, sezgi, korkular, bilinçaltı ve görünmeyen şeyler.',
    energy: 'Şu anda her şeyin göründüğü kadar net olmayabileceğini hatırlatıyor.',
  ),
  TarotCard(
    name: 'Güneş',
    suit: 'Büyük Arkana',
    meaning: 'Neşe, açıklık, başarı, mutluluk ve özgüven.',
    energy: 'Bir konunun aydınlanması ve içini rahatlatan gelişmeler.',
  ),
  TarotCard(
    name: 'Mahkeme',
    suit: 'Büyük Arkana',
    meaning: 'Uyanış, farkındalık, geçmişi değerlendirme ve önemli kararlar.',
    energy: 'Geçmişten gelen bir konuyu artık farklı gözlerle görmeye başlamak.',
  ),
  TarotCard(
    name: 'Dünya',
    suit: 'Büyük Arkana',
    meaning: 'Tamamlanma, başarı, kapanış ve yeni bir döngüye geçiş.',
    energy: 'Uzun süredir devam eden bir sürecin sonunda bir bütünlük hissi.',
  ),

  // =========================
  // DEĞNEKLER
  // =========================

  TarotCard(
    name: 'Değnek Ası',
    suit: 'Değnekler',
    meaning: 'Yeni fikir, tutku, heyecan ve harekete geçme isteği.',
    energy: 'İçinde yeniden bir kıvılcım oluşması.',
  ),
  TarotCard(
    name: 'Değnek İkilisi',
    suit: 'Değnekler',
    meaning: 'Plan yapmak, seçenekleri değerlendirmek ve geleceğe bakmak.',
    energy: 'Bir sonraki adımını seçmeden önce ihtimalleri tartmak.',
  ),
  TarotCard(
    name: 'Değnek Üçlüsü',
    suit: 'Değnekler',
    meaning: 'İlerleme, fırsatlar ve ufkun genişlemesi.',
    energy: 'Attığın adımların sonuçlarını görmeye başlaman.',
  ),
  TarotCard(
    name: 'Değnek Dörtlüsü',
    suit: 'Değnekler',
    meaning: 'Kutlama, huzur, aidiyet ve sağlam bir temel.',
    energy: 'Kendini güvende ve ait hissettiğin bir ortam.',
  ),
  TarotCard(
    name: 'Değnek Beşlisi',
    suit: 'Değnekler',
    meaning: 'Rekabet, fikir ayrılıkları ve mücadele.',
    energy: 'Birden fazla kişinin aynı alan için mücadele ettiği hareketli bir dönem.',
  ),
  TarotCard(
    name: 'Değnek Altılısı',
    suit: 'Değnekler',
    meaning: 'Başarı, takdir, özgüven ve kazanım.',
    energy: 'Çabanın fark edilmesi ve kendine güveninin artması.',
  ),
  TarotCard(
    name: 'Değnek Yedilisi',
    suit: 'Değnekler',
    meaning: 'Kendini savunmak, sınırlarını korumak ve direnmek.',
    energy: 'Sahip olduğun şeyi koruman gereken bir durum.',
  ),
  TarotCard(
    name: 'Değnek Sekizlisi',
    suit: 'Değnekler',
    meaning: 'Hızlı gelişmeler, haberler, mesajlar ve hareket.',
    energy: 'Uzun süredir bekleyen bir konunun bir anda hızlanması.',
  ),
  TarotCard(
    name: 'Değnek Dokuzlusu',
    suit: 'Değnekler',
    meaning: 'Dayanıklılık, temkin ve son bir çaba.',
    energy: 'Yorulmuş olsan bile deneyimlerinden güç alarak devam etmek.',
  ),
  TarotCard(
    name: 'Değnek Onlusu',
    suit: 'Değnekler',
    meaning: 'Yük, sorumluluk, baskı ve gereğinden fazla şey üstlenmek.',
    energy: 'Her şeyi tek başına taşımaya çalışmanın seni yorması.',
  ),
  TarotCard(
    name: 'Değnek Prensi',
    suit: 'Değnekler',
    meaning: 'Merak, heyecan, macera ve yeni bir haber.',
    energy: 'Beklenmedik bir gelişmenin seni yeniden heyecanlandırması.',
  ),
  TarotCard(
    name: 'Değnek Şövalyesi',
    suit: 'Değnekler',
    meaning: 'Tutku, hız, cesaret ve ani hareket.',
    energy: 'Düşünmekten çok harekete geçme isteğinin ağır basması.',
  ),
  TarotCard(
    name: 'Değnek Kraliçesi',
    suit: 'Değnekler',
    meaning: 'Özgüven, çekicilik, bağımsızlık ve sıcaklık.',
    energy: 'Kendi değerini daha fazla fark ettiğin bir dönem.',
  ),
  TarotCard(
    name: 'Değnek Kralı',
    suit: 'Değnekler',
    meaning: 'Liderlik, vizyon, girişimcilik ve güçlü irade.',
    energy: 'Bir konuda kontrolü ele alıp yön belirlemek.',
  ),

  // =========================
  // KUPALAR
  // =========================

  TarotCard(
    name: 'Kupa Ası',
    suit: 'Kupalar',
    meaning: 'Yeni duygular, sevgi, yakınlık ve duygusal başlangıç.',
    energy: 'Kalbinin yeniden bir şeye açılması.',
  ),
  TarotCard(
    name: 'Kupa İkilisi',
    suit: 'Kupalar',
    meaning: 'Karşılıklı çekim, bağ, uyum ve duygusal yakınlık.',
    energy: 'İki kişi arasında karşılıklı olarak hissedilen bir bağ.',
  ),
  TarotCard(
    name: 'Kupa Üçlüsü',
    suit: 'Kupalar',
    meaning: 'Arkadaşlık, kutlama, sosyallik ve paylaşım.',
    energy: 'Çevrenden gelen sıcaklığın ve birlikte geçirilen güzel zamanların artması.',
  ),
  TarotCard(
    name: 'Kupa Dörtlüsü',
    suit: 'Kupalar',
    meaning: 'İçe kapanma, ilgisizlik ve önündeki fırsatı fark edememek.',
    energy: 'Kalbinin bir şeye kapalı olması nedeniyle güzel bir ihtimali gözden kaçırmak.',
  ),
  TarotCard(
    name: 'Kupa Beşlisi',
    suit: 'Kupalar',
    meaning: 'Hayal kırıklığı, kayıp ve geçmişte kalanlara odaklanmak.',
    energy: 'Canını sıkan bir şeyin hâlâ duygusal olarak etkisini sürdürmesi.',
  ),
  TarotCard(
    name: 'Kupa Altılısı',
    suit: 'Kupalar',
    meaning: 'Geçmiş, anılar, nostalji ve geçmişten gelen kişiler.',
    energy: 'Eski bir anının, insanın veya duygunun yeniden gündeme gelmesi.',
  ),
  TarotCard(
    name: 'Kupa Yedilisi',
    suit: 'Kupalar',
    meaning: 'Seçenekler, hayaller, ihtimaller ve kafa karışıklığı.',
    energy: 'Gerçek olanla zihninde kurduğun ihtimalleri ayırman gereken bir dönem.',
  ),
  TarotCard(
    name: 'Kupa Sekizlisi',
    suit: 'Kupalar',
    meaning: 'Geride bırakmak, uzaklaşmak ve duygusal olarak yeni bir yol aramak.',
    energy: 'Sana artık iyi gelmeyen bir şeyden vazgeçme cesareti.',
  ),
  TarotCard(
    name: 'Kupa Dokuzlusu',
    suit: 'Kupalar',
    meaning: 'Dilekler, memnuniyet, keyif ve kişisel tatmin.',
    energy: 'İstediğin bir şeyin düşündüğünden daha yakın olabileceğini hissetmek.',
  ),
  TarotCard(
    name: 'Kupa Onlusu',
    suit: 'Kupalar',
    meaning: 'Duygusal bütünlük, mutluluk, aidiyet ve huzur.',
    energy: 'Kalben kendini güvende hissettiğin bir bağ veya ortam.',
  ),
  TarotCard(
    name: 'Kupa Prensi',
    suit: 'Kupalar',
    meaning: 'Duygusal haber, hassasiyet, romantizm ve samimi yaklaşım.',
    energy: 'Beklenmedik ama duygusal açıdan anlam taşıyan bir iletişim.',
  ),
  TarotCard(
    name: 'Kupa Şövalyesi',
    suit: 'Kupalar',
    meaning: 'Romantik yaklaşım, teklif, idealizm ve duyguların peşinden gitmek.',
    energy: 'Birinin duygularını daha açık şekilde göstermesi veya senin kalbini takip etmen.',
  ),
  TarotCard(
    name: 'Kupa Kraliçesi',
    suit: 'Kupalar',
    meaning: 'Empati, sezgi, duygusal derinlik ve anlayış.',
    energy: 'Söylenmeyen şeyleri bile hissedebildiğin güçlü bir sezgisel dönem.',
  ),
  TarotCard(
    name: 'Kupa Kralı',
    suit: 'Kupalar',
    meaning: 'Duygusal olgunluk, sakinlik, anlayış ve denge.',
    energy: 'Yoğun duyguları kontrol etmek yerine onları olgun biçimde yönetmek.',
  ),

  // =========================
  // KILIÇLAR
  // =========================

  TarotCard(
    name: 'Kılıç Ası',
    suit: 'Kılıçlar',
    meaning: 'Gerçek, netlik, dürüstlük ve yeni bir fikir.',
    energy: 'Kafandaki belirsizliğin bir anda netleşmesi.',
  ),
  TarotCard(
    name: 'Kılıç İkilisi',
    suit: 'Kılıçlar',
    meaning: 'Kararsızlık, iki seçenek arasında kalmak ve gerçeği ertelemek.',
    energy: 'Bir karar vermeyi geciktirmenin yarattığı iç gerilim.',
  ),
  TarotCard(
    name: 'Kılıç Üçlüsü',
    suit: 'Kılıçlar',
    meaning: 'Kalp kırıklığı, acı veren gerçekler ve duygusal yüzleşme.',
    energy: 'Canını acıtan bir gerçeği kabul ederek iyileşmeye başlamak.',
  ),
  TarotCard(
    name: 'Kılıç Dörtlüsü',
    suit: 'Kılıçlar',
    meaning: 'Dinlenme, geri çekilme ve zihinsel toparlanma.',
    energy: 'Bir konuda hemen hareket etmek yerine kendine zaman vermek.',
  ),
  TarotCard(
    name: 'Kılıç Beşlisi',
    suit: 'Kılıçlar',
    meaning: 'Çatışma, gerilim ve kazanmanın bedeli.',
    energy: 'Haklı çıkmaktan çok huzurun önemli hale gelmesi.',
  ),
  TarotCard(
    name: 'Kılıç Altılısı',
    suit: 'Kılıçlar',
    meaning: 'Geçmişten uzaklaşmak, geçiş ve daha sakin bir döneme ilerlemek.',
    energy: 'Zor bir süreci geride bırakıp zihinsel olarak hafiflemek.',
  ),
  TarotCard(
    name: 'Kılıç Yedilisi',
    suit: 'Kılıçlar',
    meaning: 'Strateji, gizlilik, dikkat ve doğrudan söylenmeyen şeyler.',
    energy: 'Her şeyi hemen açığa çıkarmadan önce gözlem yapmanın gerekliliği.',
  ),
  TarotCard(
    name: 'Kılıç Sekizlisi',
    suit: 'Kılıçlar',
    meaning: 'Kendini kısıtlanmış hissetmek ve zihinsel engeller.',
    energy: 'Asıl engelin dışarıdan çok kendi düşüncelerinden kaynaklanabileceği bir durum.',
  ),
  TarotCard(
    name: 'Kılıç Dokuzlusu',
    suit: 'Kılıçlar',
    meaning: 'Endişe, fazla düşünme ve zihinsel yük.',
    energy: 'Gerçek olaydan çok zihninde büyüyen ihtimallerin seni yorması.',
  ),
  TarotCard(
    name: 'Kılıç Onlusu',
    suit: 'Kılıçlar',
    meaning: 'Bir dönemin sona ermesi, kabullenme ve yeniden başlama.',
    energy: 'Artık sürdürülemeyen bir döngünün kapanması.',
  ),
  TarotCard(
    name: 'Kılıç Prensi',
    suit: 'Kılıçlar',
    meaning: 'Merak, araştırma, gözlem ve hızlı düşünmek.',
    energy: 'Bir şeyin arkasındaki gerçeği öğrenme isteği.',
  ),
  TarotCard(
    name: 'Kılıç Şövalyesi',
    suit: 'Kılıçlar',
    meaning: 'Hızlı hareket, doğrudan iletişim ve kararlılık.',
    energy: 'Bir konunun bir anda konuşulması veya netleşmesi.',
  ),
  TarotCard(
    name: 'Kılıç Kraliçesi',
    suit: 'Kılıçlar',
    meaning: 'Netlik, bağımsızlık, dürüstlük ve sınır koymak.',
    energy: 'Duygularını inkâr etmeden kendin için doğru olanı görmen.',
  ),
  TarotCard(
    name: 'Kılıç Kralı',
    suit: 'Kılıçlar',
    meaning: 'Mantık, objektiflik, otorite ve stratejik düşünce.',
    energy: 'Bir konuda duygudan biraz uzaklaşıp gerçekleri değerlendirmek.',
  ),

  // =========================
  // TILSIMLAR
  // =========================

  TarotCard(
    name: 'Tılsım Ası',
    suit: 'Tılsımlar',
    meaning: 'Maddi fırsat, sağlam başlangıç ve somut bir imkan.',
    energy: 'Gerçek hayatta karşılığı olan yeni bir fırsat.',
  ),
  TarotCard(
    name: 'Tılsım İkilisi',
    suit: 'Tılsımlar',
    meaning: 'Denge kurmak, zaman yönetimi ve birden fazla sorumluluğu taşımak.',
    energy: 'Hayatındaki farklı alanları aynı anda yürütmeye çalışmak.',
  ),
  TarotCard(
    name: 'Tılsım Üçlüsü',
    suit: 'Tılsımlar',
    meaning: 'Ekip çalışması, öğrenme, beceri ve emek.',
    energy: 'Bir konuda başkalarıyla birlikte ilerleyerek gelişmek.',
  ),
  TarotCard(
    name: 'Tılsım Dörtlüsü',
    suit: 'Tılsımlar',
    meaning: 'Güvenlik, sahip olduklarını korumak ve kontrol.',
    energy: 'Kaybetme korkusunun seni yeni bir şeye açılmaktan alıkoyması.',
  ),
  TarotCard(
    name: 'Tılsım Beşlisi',
    suit: 'Tılsımlar',
    meaning: 'Zorluk, dışlanmış hissetmek ve destek aramak.',
    energy: 'Kendini yalnız hissetsen bile yardımın aslında yakınında olabileceği.',
  ),
  TarotCard(
    name: 'Tılsım Altılısı',
    suit: 'Tılsımlar',
    meaning: 'Yardımlaşma, paylaşım, destek ve karşılıklılık.',
    energy: 'Birinden destek almak veya birine destek olmak.',
  ),
  TarotCard(
    name: 'Tılsım Yedilisi',
    suit: 'Tılsımlar',
    meaning: 'Sabır, emek ve sonuçları beklemek.',
    energy: 'Çabanın hemen karşılığını görmesen bile sürecin devam etmesi.',
  ),
  TarotCard(
    name: 'Tılsım Sekizlisi',
    suit: 'Tılsımlar',
    meaning: 'Çalışmak, öğrenmek, uzmanlaşmak ve disiplin.',
    energy: 'Küçük ama düzenli adımların uzun vadede büyük fark yaratması.',
  ),
  TarotCard(
    name: 'Tılsım Dokuzlusu',
    suit: 'Tılsımlar',
    meaning: 'Bağımsızlık, konfor, özgüven ve emeğin karşılığı.',
    energy: 'Kendi ayaklarının üzerinde durmanın verdiği güven.',
  ),
  TarotCard(
    name: 'Tılsım Onlusu',
    suit: 'Tılsımlar',
    meaning: 'Uzun vadeli güvenlik, aile, düzen ve kalıcılık.',
    energy: 'Geçici heyecanlardan çok kalıcı bir temel kurma isteği.',
  ),
  TarotCard(
    name: 'Tılsım Prensi',
    suit: 'Tılsımlar',
    meaning: 'Öğrenme, fırsat, çalışkanlık ve güvenilir başlangıç.',
    energy: 'Yavaş ama sağlam ilerleyen yeni bir süreç.',
  ),
  TarotCard(
    name: 'Tılsım Şövalyesi',
    suit: 'Tılsımlar',
    meaning: 'Sabır, istikrar, güvenilirlik ve sorumluluk.',
    energy: 'Hızlı sonuç yerine sağlam ilerlemeyi seçmek.',
  ),
  TarotCard(
    name: 'Tılsım Kraliçesi',
    suit: 'Tılsımlar',
    meaning: 'Pratiklik, güven, üretkenlik ve kendine iyi bakmak.',
    energy: 'Hem maddi hem duygusal olarak kendine güvenli bir alan oluşturmak.',
  ),
  TarotCard(
    name: 'Tılsım Kralı',
    suit: 'Tılsımlar',
    meaning: 'Maddi istikrar, başarı, güven ve sağlamlık.',
    energy: 'Uzun vadeli ve güvenilir bir sonuç oluşturma isteği.',
  ),
];

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  int selectedSpread = 0;

  final List<Map<String, dynamic>> spreads = [
    {
      'title': 'Günün Kartı',
      'subtitle': 'Bugünün enerjisine odaklan',
      'description':
          'Bugünün duygusal ve enerjik temasını keşfet.',
      'icon': '✨',
      'count': 1,
    },
    {
      'title': 'Aşk Açılımı',
      'subtitle': 'İlişkiler ve duygusal bağlar',
      'description':
          'Sen, karşı taraf, aranızdaki enerji ve ilişkinin yönünü keşfet.',
      'icon': '💗',
      'count': 4,
    },
    {
      'title': 'Üç Kart',
      'subtitle': 'Geçmiş • Şimdi • Gelecek',
      'description':
          'Bir konunun geçmişten bugüne taşıdığı enerjiyi ve olası yönünü incele.',
      'icon': '🔮',
      'count': 3,
    },
    {
      'title': 'Karar Açılımı',
      'subtitle': 'İki farklı yolu değerlendir',
      'description':
          'Bir kararın arkasındaki enerjileri ve gözden kaçabilecek noktaları keşfet.',
      'icon': '⚖️',
      'count': 5,
    },
    {
      'title': 'Kelt Haçı',
      'subtitle': 'Detaylı 10 kartlık açılım',
      'description':
          'Bir konuya geçmişi, bugünü, çevreni ve olası gelişmeleriyle daha derin bak.',
      'icon': '🌙',
      'count': 10,
    },
  ];

  void _startReading() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarotDrawScreen(
          spreadTitle: spreads[selectedSpread]['title'],
          cardCount: spreads[selectedSpread]['count'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔮 Tarot',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bir açılım seç, kartlarını çek ve sembollerin sana ne anlattığına bak.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Açılımını seç',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ...List.generate(
                spreads.length,
                (index) {
                  final spread = spreads[index];
                  final selected = selectedSpread == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSpread = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF312E81)
                            : const Color(0xFF17102D),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF8B5CF6)
                              : Colors.white12,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                spread['icon'],
                                style: const TextStyle(fontSize: 27),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spread['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  spread['subtitle'],
                                  style: const TextStyle(
                                    color: Color(0xFFB794F4),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  spread['description'],
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected
                                ? const Color(0xFFB794F4)
                                : Colors.white38,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _startReading,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text(
                    'Açılımı Başlat',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarotDrawScreen extends StatefulWidget {
  final String spreadTitle;
  final int cardCount;

  const TarotDrawScreen({
    super.key,
    required this.spreadTitle,
    required this.cardCount,
  });

  @override
  State<TarotDrawScreen> createState() => _TarotDrawScreenState();
}

class _TarotDrawScreenState extends State<TarotDrawScreen> {
  final Random random = Random();
  final List<TarotCard> selectedCards = [];

  bool isDrawing = false;

  void _drawCard() {
    if (selectedCards.length >= widget.cardCount) {
      _showResult();
      return;
    }

    setState(() {
      isDrawing = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      final available = tarotCards
          .where((card) => !selectedCards.contains(card))
          .toList();

      final card = available[random.nextInt(available.length)];

      setState(() {
        selectedCards.add(card);
        isDrawing = false;
      });
    });
  }

  void _showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarotResultScreen(
          spreadTitle: widget.spreadTitle,
          selectedCards: selectedCards,
        ),
      ),
    );
  }

  String get instruction {
    if (selectedCards.isEmpty) {
      return 'Desteyi karıştır ve ilk kartını çek.';
    }

    if (selectedCards.length < widget.cardCount) {
      return 'Kartların açılımındaki yerlerini buluyor...';
    }

    return 'Açılımın tamamlandı ✨';
  }

  @override
  Widget build(BuildContext context) {
    final completed = selectedCards.length == widget.cardCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spreadTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              '${selectedCards.length} / ${widget.cardCount}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Center(
                child: isDrawing
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 95,
                            height: 145,
                            child: CardBack(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Kartların enerjisi açılıyor...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    : selectedCards.isEmpty
                        ? const CardBack()
                        : Wrap(
                            spacing: 12,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              selectedCards.length,
                              (index) => _buildCard(
                                selectedCards[index],
                                index,
                              ),
                            ),
                          ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: isDrawing
                    ? null
                    : completed
                        ? _showResult
                        : _drawCard,
                icon: Icon(
                  completed
                      ? Icons.visibility
                      : Icons.auto_awesome,
                ),
                label: Text(
                  completed
                      ? 'Yorumumu Gör'
                      : selectedCards.isEmpty
                          ? 'Kart Çek'
                          : 'Sonraki Kartı Çek',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(TarotCard card, int index) {
    return Container(
      width: 105,
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF312E81),
            Color(0xFF6D28D9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '✦',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            card.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '#${index + 1}',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF17102D),
            Color(0xFF6D28D9),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFB794F4),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Text(
          '✦',
          style: TextStyle(
            fontSize: 42,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class TarotResultScreen extends StatelessWidget {
  final String spreadTitle;
  final List<TarotCard> selectedCards;

  const TarotResultScreen({
    super.key,
    required this.spreadTitle,
    required this.selectedCards,
  });

  void _showTopMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF17102D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isError
                      ? Colors.redAccent.withValues(alpha: 0.45)
                      : const Color(0xFF8B5CF6)
                          .withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isError
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                    color: isError
                        ? Colors.redAccent
                        : const Color(0xFFB794F4),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 2), () {
    entry.remove();
  });
}

  String _positionName(int index) {
    switch (spreadTitle) {
      case 'Günün Kartı':
        return 'Bugünün Kartı';

      case 'Aşk Açılımı':
        const positions = [
          'Senin Enerjin',
          'Karşı Tarafın Enerjisi',
          'Aranızdaki Bağ',
          'İlişkinin Yönü',
        ];
        return positions[index];

      case 'Üç Kart':
        const positions = [
          'Geçmiş',
          'Şimdi',
          'Olası Gelecek',
        ];
        return positions[index];

      case 'Karar Açılımı':
        const positions = [
          'Mevcut Durum',
          'Seçenek A',
          'Seçenek B',
          'Gözden Kaçan Nokta',
          'Rehberlik',
        ];
        return positions[index];

      case 'Kelt Haçı':
        const positions = [
          'Mevcut Durum',
          'Karşıt Etki',
          'Temel Enerji',
          'Geçmiş',
          'Olası Gelişme',
          'Yakın Gelecek',
          'Sen',
          'Çevre',
          'Umutlar ve Korkular',
          'Sonuç Enerjisi',
        ];
        return positions[index];

      default:
        return 'Kart ${index + 1}';
    }
  }

  String _positionIntroduction(int index) {
    switch (spreadTitle) {
      case 'Günün Kartı':
        return 'Bugünün enerjisinde öne çıkan tema şu:';

      case 'Aşk Açılımı':
        const texts = [
          'Bu kart senin şu anda ilişkiye ve duygusal bağlara yaklaşımını anlatıyor.',
          'Bu kart karşı tarafın enerjisinde öne çıkan duygusal temayı gösteriyor.',
          'Bu kart ikinizin arasında hissedilen ortak enerjiyi anlatıyor.',
          'Bu kart ilişkinin şu anki enerjisinin hangi yöne doğru aktığını gösteriyor.',
        ];
        return texts[index];

      case 'Üç Kart':
        const texts = [
          'Geçmişte yaşananların bugünkü duruma bıraktığı iz şu şekilde görünüyor:',
          'Şu anda içinde bulunduğun enerjinin merkezinde şu tema var:',
          'Bu kart geleceğe dair kesin bir kehanetten çok mevcut enerjinin götürebileceği yönü gösteriyor:',
        ];
        return texts[index];

      case 'Karar Açılımı':
        const texts = [
          'Öncelikle içinde bulunduğun durumun arkasındaki enerjiye bakalım:',
          'Birinci seçeneğin taşıdığı sembolik enerji şu:',
          'İkinci seçeneğin taşıdığı sembolik enerji şu:',
          'Karar verirken fark etmemiş olabileceğin nokta şu olabilir:',
          'Kartların sana bıraktığı temel mesaj şu:',
        ];
        return texts[index];

      case 'Kelt Haçı':
        const texts = [
          'Şu anda hayatındaki ana tabloyu bu kart anlatıyor:',
          'Bu kart mevcut enerjiyi zorlayan veya onunla çatışan etkiyi gösteriyor:',
          'Meselenin altında yatan temel enerji burada ortaya çıkıyor:',
          'Geçmişten bugüne taşınan tema şu:',
          'Yakın süreçte ortaya çıkabilecek gelişmenin enerjisi şu:',
          'Önündeki kısa dönemin atmosferi şu şekilde görünüyor:',
          'Senin bu konuya yaklaşımını gösteren enerji şu:',
          'Çevrenden gelen etkiyi bu kart anlatıyor:',
          'İçinde taşıdığın umutlar ve çekinceler burada görünür hale geliyor:',
          'Bütün kartların oluşturduğu tabloya bakıldığında sonuç enerjisi şu:',
        ];
        return texts[index];

      default:
        return 'Bu kartın açılımındaki mesajı şöyle okunabilir:';
    }
  }

  String _cardInterpretation(TarotCard card, int index) {
    final intro = _positionIntroduction(index);

    return '$intro\n\n'
        '${card.meaning} '
        '${card.energy}';
  }

    Future<void> _saveReading(BuildContext context) async {
    try {
      final cards = List.generate(
        selectedCards.length,
        (index) => {
          'position': _positionName(index),
          'name': selectedCards[index].name,
          'suit': selectedCards[index].suit,
        },
      );

      await TarotService.saveReading(
        spreadTitle: spreadTitle,
        cards: cards,
        overallReading: _overallReading(),
      );

      if (!context.mounted) return;

      _showTopMessage(
  context,
  'Açılımın başarıyla kaydedildi ✨',
);

    } catch (e) {
      if (!context.mounted) return;

      _showTopMessage(
  context,
  'Açılım kaydedilemedi: $e',
  isError: true,
);
    }
  }

Future<void> _shareReading() async {
  final buffer = StringBuffer();

  buffer.writeln('🔮 Cosmica Tarot');
  buffer.writeln();
  buffer.writeln('✨ $spreadTitle');
  buffer.writeln();

  for (int i = 0; i < selectedCards.length; i++) {
    final card = selectedCards[i];

    buffer.writeln('🃏 ${_positionName(i)}');
    buffer.writeln('${card.name} • ${card.suit}');
    buffer.writeln(card.meaning);
    buffer.writeln(card.energy);
    buffer.writeln();
  }

  buffer.writeln('✨ Cosmica ile kendi sembolik tarot açılımını keşfet.');

  await SharePlus.instance.share(
    ShareParams(
      text: buffer.toString(),
    ),
  );
}

  String _overallReading() {
    if (selectedCards.isEmpty) {
      return '';
    }

    final names = selectedCards.map((card) => card.name).join(', ');

    if (spreadTitle == 'Aşk Açılımı') {
      return 'Bu açılımda $names kartları birlikte ortaya çıktı. '
          'Kartları tek tek okumaktan daha önemli olan şey, aralarındaki ortak temayı fark etmek. '
          'Burada özellikle duyguların nasıl ifade edildiği, karşılıklı beklentiler '
          've iki kişinin birbirine yaklaşma biçimi öne çıkıyor. '
          'Açılım, tek bir olayın kesin sonucunu söylemekten ziyade '
          'ilişkide şu anda hangi duygusal dinamiklerin daha görünür olduğunu gösteren '
          'bir ayna gibi düşünülebilir.';
    }

    if (spreadTitle == 'Üç Kart') {
      return '$names kartlarının oluşturduğu tablo, geçmişte yaşananların '
          'bugünkü düşüncelerini ve bundan sonra değerlendirebileceğin yönleri '
          'birbirine bağlı şekilde ele alıyor. '
          'Özellikle geçmişten gelen bir duygunun veya düşüncenin hâlâ bugünkü '
          'kararlarını etkileyip etkilemediğine dikkat etmek önemli olabilir. '
          'Son kartı kesin bir gelecek tahmini olarak değil, mevcut enerjinin '
          'devam etmesi halinde ortaya çıkabilecek sembolik yön olarak düşün.';
    }

    if (spreadTitle == 'Karar Açılımı') {
      return 'Bu açılımda $names kartları ortaya çıktı. '
          'Buradaki amaç senin yerine bir karar vermek değil; '
          'iki seçeneğin taşıdığı farklı temaları görünür hale getirmek. '
          'Özellikle gözden kaçan nokta ve rehberlik kartları, '
          'ilk bakışta seçeneklerin kendisinden daha önemli bir farkındalık yaratabilir. '
          'Kararı verirken kartların söylediklerinden çok, '
          'hangi yorumun sende gerçekten bir karşılık oluşturduğuna dikkat edebilirsin.';
    }

    if (spreadTitle == 'Kelt Haçı') {
      return 'Kelt Haçı açılımındaki $names kartları birlikte düşünüldüğünde '
          'tek bir olaydan çok daha geniş bir hikâye ortaya çıkıyor. '
          'Geçmiş, mevcut durum, çevresel etkiler, iç dünyan ve önündeki olası yönler '
          'birbirini tamamlayan parçalar gibi okunabilir. '
          'Bu açılımın en güçlü tarafı tek bir karta bakıp sonuç çıkarmak yerine '
          'aynı konunun farklı açılardan nasıl göründüğünü göstermesidir. '
          'Sonuç kartını kesin bir gelecek haberi olarak değil, '
          'şu anki enerjilerin devamı halinde üzerinde düşünebileceğin bir tema olarak değerlendir.';
    }

    final card = selectedCards.first;

    return '${card.name} bugün açılımının merkezindeki sembol. '
        '${card.meaning} '
        '${card.energy} '
        'Bu kartın sana bırakabileceği en önemli soru, '
        'hayatında şu anda bu temanın nerede karşılık bulduğunu fark etmek olabilir.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot Yorumun'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
        child: Column(
          children: [
            const Text(
              '🔮',
              style: TextStyle(fontSize: 58),
            ),
            const SizedBox(height: 8),
            Text(
              spreadTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kartlarının sembolik hikâyesini keşfet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),

            ...List.generate(
              selectedCards.length,
              (index) {
                final card = selectedCards[index];

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17102D),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _positionName(index),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFB794F4),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),

                      Container(
  width: 105,
  height: 145,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF312E81),
        Color(0xFF6D28D9),
      ],
    ),
  ),
  child: const Center(
    child: Text(
      '✦',
      style: TextStyle(
        fontSize: 50,
        color: Colors.white,
      ),
    ),
  ),
),
                      const SizedBox(height: 18),

                      Text(
                        card.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        card.suit,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _cardInterpretation(card, index),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.65,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 5),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF312E81).withValues(alpha: 0.7),
                    const Color(0xFF4C1D95).withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '✨ Genel Yorum',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _overallReading(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Tarot kartları kesin gelecek tahminleri sunmaz. '
              'Bu açılımı kendini, duygularını ve içinde bulunduğun durumu '
              'farklı bir açıdan düşünmek için sembolik bir araç olarak kullanabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

           OutlinedButton.icon(
  onPressed: () => _saveReading(context),
  icon: const Icon(Icons.bookmark_outline),
  label: const Text('Açılımı Kaydet'),
),

const SizedBox(height: 10),

OutlinedButton.icon(
  onPressed: _shareReading,
  icon: const Icon(Icons.share_outlined),
  label: const Text('Açılımı Paylaş'),
),

const SizedBox(height: 10),

OutlinedButton.icon(
  onPressed: () {
    Navigator.of(context).popUntil((route) => route.isFirst);
  },
  icon: const Icon(Icons.home_outlined),
  label: const Text('Ana Sayfaya Dön'),
),
          ],
        ),
      ),
    );
  }
}