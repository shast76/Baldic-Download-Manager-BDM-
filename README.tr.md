# Baldic Download Manager

🇬🇧 [English](README.md) · 🇹🇷 Türkçe

IDM benzeri, açık kaynaklı (MIT), **Material 3 Expressive** arayüzlü indirme yöneticisi.
*An open-source, IDM-style download manager with a Material 3 Expressive UI, yt-dlp / ffmpeg support and a Chrome extension.*

![Koyu tema](docs/screenshot-dark.png)

## Özellikler
- **Çok bağlantılı indirme** (dosya başına 1–16 parça), duraklat / devam et, yeniden başlatınca kaldığı yerden sürdürme, kuyruk (aynı anda N indirme)
- **Chrome eklentisi:** Chrome'da başlayan indirmeyi yakalar, çerezleri/referer'ı aktarır; **Baldic'in kendi masaüstü penceresi öne gelip** indirme seçeneklerini gösterir (Chrome'da hiçbir pencere/sekme açılmaz)
- **YouTube ve yüzlerce site** (yt-dlp): kalite seçimi (en iyi … 360p), MP4 / MKV / WEBM, yalnızca ses (MP3, M4A, OPUS, FLAC, WAV, AAC), kapak görseli indirme (JPG / PNG / WEBP), altyazı / kapak / etiket gömme
- **Format dönüştürme** (ffmpeg): video (MP4, MKV, WEBM, MOV, AVI, GIF), ses, **fotoğraf** (JPG, PNG, WEBP, AVIF, BMP, TIFF, GIF); kalite ve çözünürlük seçimi; indirme bitince otomatik dönüştürme
- Kategoriler (Sıkıştırılmış, Belgeler, Müzik, Video, Görseller, Programlar), sağ tık menüsü, Ctrl+V ile bağlantı yapıştırma, sürükle-bırak
- İki tema: **Koyu** (varsayılan) ve **Turuncu** (`#ee8206` zemin, `#b44900` vurgu, `#3e180d` buton)
- **Türkçe / İngilizce arayüz** (Ayarlar → Dil; varsayılan sistem diline göre)
- yt-dlp ve ffmpeg'i **Ayarlar → Araçlar** bölümünden tek tıkla kurma/güncelleme (Windows / Linux; macOS'ta `brew install ffmpeg`)

## Kurulum

### Kurulum sihirbazı (Windows, önerilen)
`Baldic-Setup.exe` adım adım bir sihirbazla (Türkçe / İngilizce) kurar: kurulum klasörü, Başlat menüsü ve masaüstü kısayolları, isteğe bağlı *Windows ile başlat*, Chrome eklentisi klasörü ve temiz bir kaldırıcı. Yönetici izni gerekmez (varsayılan: kullanıcıya özel kurulum).
- GitHub'a yükledikten sonra **Actions → Build Windows exe → Run workflow** ile otomatik derlenir; `Baldic-Setup.exe`, taşınabilir `Baldic.exe` ve eklenti zip'i *Artifacts* altında çıkar. `v1.0.0` gibi bir etiket (tag) atarsanız *Releases*'e de eklenir.
- Ya da kendi bilgisayarınızda: Python 3.8+ ve [Inno Setup 6](https://jrsoftware.org/isdl.php) kurun, `build-windows.bat` dosyasına çift tıklayın → `dist\Baldic.exe` ve `dist\Baldic-Setup.exe` (Inno Setup yoksa yine taşınabilir `Baldic.exe` çıkar).

Tek başına `Baldic.exe` taşınabilir bir dosyadır ve kendi penceresinde çalışır (Windows'un yerleşik WebView2'sini kullanır).

### Arka planda çalışma
**Ayarlar → Arka plan** bölümünden; pencereyi kapatınca Baldic'in **sistem tepsisinde** çalışmaya devam edip etmeyeceğini (varsayılan: açık), **Windows ile başlayıp başlamayacağını** ve açılışta **tepsiye küçülüp küçülmeyeceğini** siz seçersiniz. Tepsi simgesine sol tıklayınca pencere açılır, sağ tıklayınca *Tümünü duraklat / sürdür / Çıkış* menüsü gelir. Elle tepside başlatmak için `--hidden` kullanın.

### Kaynaktan çalıştırma
```bash
pip install pywebview          # yerel pencere için
python app/baldic.py           # Windows'ta start-windows.bat, Linux/macOS'ta ./start.sh
python app/baldic.py --browser     # pencere yerine tarayıcıda aç
python app/baldic.py --no-window   # arka planda çalıştır
```
Ardından **Ayarlar → Araçlar**'dan yt-dlp ve ffmpeg'i kurun (ya da kendiniz kurup PATH'e ekleyin).

### Chrome eklentisi
1. `chrome://extensions` → sağ üstten **Geliştirici modu**
2. **Paketlenmemiş öğe yükle** → bu projedeki `extension/` klasörü
3. Baldic (exe) açıkken bir dosya indirin: Baldic penceresi açılır. Baldic kapalıysa eklenti karışmaz, indirme Chrome'da normal sürer.

Araç çubuğundaki simgeden yakalamayı kapatabilir veya **"Bu sayfadaki videoyu indir"** diyebilirsiniz.

### Sorun giderme
- **"Port 6877 meşgul" uyarısı:** Önceki bir Baldic arka planda açık kalmış olabilir. Yeni sürüm bunu otomatik algılar: açık pencereyi öne getirir, pencersiz eski bir süreci ise kapatıp yerine geçer. Başka bir program portu kullanıyorsa `Baldic.exe --port 6900` ile başlatın (Chrome eklentisi 6877 bekler).

## Mimari
```
Chrome ──(eklenti)──► POST /api/pending ──► Baldic (Python, http://127.0.0.1:6877)
                                              ├─ çok parçalı HTTP motoru
                                              ├─ yt-dlp süreci (ilerleme ayrıştırma)
                                              ├─ ffmpeg süreci (dönüştürme)
                                              └─ Web arayüzü (app/ui) — tarayıcı / pywebview
```
## Güvenlik
Sunucu yalnızca `127.0.0.1`'e bağlanır; `Host` ve `Origin` kontrolü yapılır (web siteleri API'ye erişemez, yalnızca arayüz ve eklenti erişebilir). Sadece `http(s)` bağlantıları kabul edilir. Çerezler çapraz-alan yönlendirmelerinde gönderilmez.

## Testler
```bash
python -m unittest discover tests -v   # ffmpeg PATH'teyse dönüştürme testleri de çalışır
```
yt-dlp testlerde `tests/fake_ytdlp.py` ile taklit edilir.

## Bilinen sınırlar / yol haritası
- Gerçek YouTube indirmesi bu projeyi yazarken sandbox'ta (internetsiz) denenemedi; yt-dlp entegrasyonu çıktı biçimi ve komut satırı düzeyinde testlidir. YouTube sorunlarında yt-dlp'yi güncelleyin; son sürümler YouTube için ayrıca bir JavaScript çalışma zamanı (Deno) isteyebilir — bkz. yt-dlp wiki.
- Yapılacaklar: sistem tepsisi, zamanlayıcı, hız sınırı, Firefox eklentisi, çalma listesi desteği, sağlama toplamı doğrulama.

## Lisans
MIT — bkz. [LICENSE](LICENSE).
