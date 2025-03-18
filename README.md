# Tugas Merubah Arsitektur Aplikasi Dari Monolith Menjadi Microservice

#### Nama: Bagas Andreanto
#### NIM: 122140017
#### Kelas: Pemrograman Web Lanjut - R


Link Sumber Repo Aplikasi Monolit: [Django E-commerce project amazone clone](https://github.com/hackstarsj/django-ecommerce-project-amazon-clone)

## Django E-Commerce Project: Amazon Clone

Proyek ini adalah sebuah klon sederhana dari Amazon yang dibangun menggunakan framework Django. Aplikasi ini dirancang untuk mempelajari dan mengimplementasikan konsep e-commerce seperti manajemen pengguna, katalog produk, sistem pembayaran, dan manajemen pesanan.

### Struktur Proyek

django-ecommerce-project-amazon-clone-master/  
│── DjangoEcommerce/              # Folder utama Django (main project)  
│── DjangoEcommerceApp/           # Aplikasi utama  
│── media/                        # Media storage  
│── screenshots/                   # Folder berisi tangkapan layar  
│── static/                        # Folder untuk static files  
│── db.sqlite3                     # Database SQLite  
│── manage.py                      # File utama untuk menjalankan Django  
│── DjangoEcommerce/settings.py    # Konfigurasi proyek  
│── DjangoEcommerce/urls.py        # Routing utama  
│── README.md                      # Dokumentasi proyek  
│── DjangoEcommerce.pptx           # File presentasi proyek  
  

### Fitur Utama

✅ **Manajemen Pengguna** – Login, registrasi, dan profil pengguna.  
✅ **Katalog Produk** – Manajemen produk, kategori, dan fitur pencarian.  
✅ **Sistem Pembayaran** – Proses checkout dan transaksi.  
✅ **Manajemen Pesanan** – Riwayat pesanan dan status pesanan.  
✅ **Admin Panel** – Manajemen data melalui Django Admin.  

### Arsitektur

Aplikasi ini menggunakan arsitektur **monolitik**, di mana semua fitur dikelola dalam satu basis kode dan menggunakan satu database SQLite untuk pengembangan.   

## BAB 2 - PLANING A MIGRATION

### 1. Identifikasi Komponen yang Akan Dipisah
Proses identifikasi ini dimulai dengan menganalisis struktur proyek yang ada untuk memetakan file dan fungsionalitasnya ke dalam layanan-layanan baru. Hal ini dilakukan agar dapat memisahkan aplikasi monolitik menjadi beberapa layanan yang lebih modular dan terpisah. Berikut adalah pemetaan yang saya buat:

| **Layanan Baru**       | **File/Folder dalam Proyek** |
|------------------------|----------------------------|
| **Layanan Autentikasi** (Login, Register, User) | `users/models.py`, `users/views.py`, `users/urls.py` |
| **Layanan Katalog Produk** (Produk, Kategori) | `products/models.py`, `products/views.py`, `products/urls.py` |
| **Layanan Transaksi & Pesanan** (Checkout, Order, Payment) | `orders/models.py`, `orders/views.py`, `orders/urls.py` |

Tujuan dari pemisahan komponen ini akan mempermudah pengembangan, pemeliharaan, dan penskalaan aplikasi di masa depan. Setiap layanan dapat dikembangkan secara independen, dan masalah di satu layanan tidak akan memengaruhi layanan lainnya.

### 2. Rencana Pemisahan API

Memisahkan setiap layanan menjadi API yang terpisah. Ini akan memungkinkan komunikasi antar-layanan melalui protokol HTTP/HTTPS. Untuk membangun API, saya akan menggunakan **Django REST Framework (DRF)** karena framework ini sudah terintegrasi dengan baik dengan Django dan mudah digunakan. Pemishan API ini digunakan untuk dapat memudahkan integrasi dengan sistem lain di masa depan dan memungkinkan pengembangan layanan secara independen.

Berikut adalah endpoint yang akan saya buat untuk masing-masing layanan:  
- `/api/auth/` → Login, register, profile  
- `/api/products/` → List produk, pencarian  
- `/api/orders/` → Checkout, histori transaksi

### 3. Menentukan Teknologi yang Akan Digunakan

| **Layanan**  | **Framework** | **Database** |
|-------------|--------------|--------------|
| Autentikasi  | Django + DRF  | PostgreSQL  |
| Katalog Produk | FastAPI / Django | MongoDB |
| Transaksi & Pesanan | Django + Celery | PostgreSQL |

### 4. Evaluasi Risiko & Rencana Backup
Saya menyadari bahwa migrasi ini memiliki beberapa risiko, seperti downtime dan ketidakkonsistenan data. Oleh karena itu, saya merencanakan beberapa strategi untuk meminimalkan risiko:

- **Downtime Minim:** Saya akan menggunakan pendekatan **strangler pattern**, yaitu memigrasi aplikasi secara bertahap. Ini akan meminimalkan downtime dan memungkinkan pengguna untuk tetap menggunakan aplikasi selama proses migrasi.  
- **Data Consistency:** Saya akan membuat **data migration script** untuk memindahkan data pengguna dan produk dari SQLite ke PostgreSQL dan MongoDB. Ini memastikan bahwa data tetap konsisten selama migrasi.  
- **Keamanan API:** Saya akan mengimplementasikan **JWT Authentication** untuk setiap layanan agar komunikasi antar-layanan aman dan terautentikasi.  

Untuk mengoptimalkan migrasi dari monolith ke microservice menggunakan **Docker** untuk menyiapkan lingkungan pengembangan yang konsisten dan mudah di-deploy. Docker memastikan bahwa setiap layanan dapat berjalan di lingkungan yang terisolasi dan konsisten, mengurangi masalah yang disebabkan oleh perbedaan lingkungan pengembangan dan produksi.

---

## BAB 3 - SPLITTING THE MONOLITH
### Struktur Direktori Proyek Microservices

Setelah melakukan ekstraksi dari aplikasi monolitik, saya mengatur direktori proyek menjadi beberapa layanan microservices yang terpisah. Struktur ini dirancang untuk memastikan setiap layanan memiliki tanggung jawab yang jelas dan dapat dikembangkan secara independen. Berikut adalah penjelasan tentang struktur direktori yang telah saya buat:

### **Layanan Autentikasi (`auth_service/`)**
Layanan ini bertanggung jawab untuk mengelola autentikasi pengguna, termasuk proses login, registrasi, dan manajemen profil. Saya memindahkan file-file yang terkait dengan autentikasi dari direktori `DjangoEcommerceApp/` ke dalam `auth_service/`. Struktur direktori ini mencakup:
- `migrations/` → Berisi file migrasi database.
- `static/` → Berisi file statis seperti CSS, JavaScript, dan gambar.
- `templates/` → Berisi file template HTML untuk tampilan antarmuka pengguna.
- `manage.py` → File utilitas untuk mengelola proyek Django.
- `settings.py` → Konfigurasi aplikasi.
- `urls.py` → Routing untuk endpoint API.
- `models.py` → Definisi model database.
- `views.py` → Logika bisnis untuk autentikasi.

### **Layanan Katalog Produk (`product_service/`)**
Layanan ini mengelola katalog produk, termasuk menampilkan daftar produk, kategori, dan fitur pencarian. Saya memindahkan file-file terkait produk dari `DjangoEcommerceApp/` ke dalam `product_service/`. Struktur direktori ini mirip dengan `auth_service/`, dengan komponen-komponen seperti `models.py`, `views.py`, dan `urls.py` yang disesuaikan untuk kebutuhan katalog produk.


### **Layanan Pemesanan (`order_service/`)**
Layanan ini bertanggung jawab untuk mengelola proses pemesanan, termasuk checkout, pembayaran, dan riwayat transaksi. Saya memindahkan file-file terkait pemesanan dari `DjangoEcommerceApp/` ke dalam `order_service/`. Struktur direktori ini juga mengikuti pola yang sama, dengan penyesuaian untuk logika bisnis dan model yang terkait dengan pemesanan.


### **API Gateway (`gateway_service/`)**
API Gateway berfungsi sebagai pintu masuk utama untuk semua permintaan dari klien ke microservices. Layanan ini akan mengarahkan permintaan ke layanan yang sesuai (`auth_service`, `product_service`, atau `order_service`) dan mengelola autentikasi, logging, serta load balancing. Saya menyiapkan direktori `gateway_service/` dengan struktur yang serupa, tetapi fokusnya adalah pada pengelolaan routing dan integrasi antar-layanan.


### **Struktur Utama Proyek**
Berikut adalah gambaran struktur utama proyek setelah pemisahan microservices:

![Penambahan Direktori Folder Microservice](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png)

![Penghapusan Beberapa Folder Yang Tidak Diperlukan](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png)

Melakukan Update Pada code setting.py di semua file service (auth, product, order)
```
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'your-secret-key'
DEBUG = True

ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'auth_app',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'auth_service.urls' # Sesuai dengan lokasi filenya (auth, product, atau order)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

CORS_ALLOW_ALL_ORIGINS = True
```

### **Melakukan Integrasi Gateway Service**
Gateway digunakan karena berfungsi sebagai titik masuk yang mempermudah pengelolaan komunikasi antara client/frontend dengan berbagai layanan backend. Dengan menggunakan gateway, arsitektur sistem menjadi lebih terstruktur, aman, dan efisien, karena semua permintaan dari client dapat diproses melalui satu titik yang mengelola routing, otentikasi, dan otorisasi. Hal ini mengurangi kompleksitas di sisi client, memungkinkan integrasi layanan yang lebih mudah, serta meningkatkan keamanan dan pengelolaan lalu lintas data antar sistem. 
code:
```
import requests
from django.http import JsonResponse

def get_product(request, product_id):
    response = requests.get(f'http://127.0.0.1:8002/{product_id}/')
    return JsonResponse(response.json(), safe=False)

def get_order(request, order_id):
    response = requests.get(f'http://127.0.0.1:8003/orders/{order_id}/')
    return JsonResponse(response.json(), safe=False)

```

### **API Komunikasi Antar Layanan**
Komunikasi antar layanan dalam sistem yang dibangun menggunakan Django dapat dilakukan dengan memanfaatkan HTTP request menggunakan Django requests module. Modul ini memungkinkan aplikasi Django untuk melakukan permintaan HTTP ke layanan lain, baik dalam sistem yang sama (misalnya antar microservices) atau ke layanan eksternal. Django's requests module menyederhanakan proses ini dengan menyediakan fungsi untuk mengirimkan berbagai jenis HTTP request (seperti GET, POST, PUT, DELETE) dan menangani respons yang diterima, memudahkan pengembangan aplikasi berbasis API. 
code:
```
import requests
from django.http import JsonResponse

def get_product_details(request, product_id):
    response = requests.get(f'http://127.0.0.1:8002/{product_id}/')
    if response.status_code == 200:
        return JsonResponse(response.json(), safe=False)
    return JsonResponse({'error': 'Product not found'}, status=404)
```

![Tampilan Akhir Direktori](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png)

---

## BAB 4 - DECOMPOSING THE DATABASE

### **Dekomposisi Database untuk Arsitektur Microservices**

Dalam proyek ini, saya melakukan dekomposisi database dari arsitektur monolitik ke arsitektur microservices. Tujuannya adalah untuk memisahkan tanggung jawab database sesuai dengan layanan yang ada, sehingga setiap layanan dapat memiliki database sendiri dan beroperasi secara independen. Berikut adalah penjelasan lengkap tentang proses dekomposisi database yang saya lakukan.

#### **1. Analisis Database Monolitik (Sebelum Dekomposisi)**

Pada sistem monolitik, semua tabel database berada dalam satu database tunggal. Berikut adalah tabel-tabel utama yang ada:

| **Tabel**       | **Fungsi** |
|----------------|-----------|
| `users` | Menyimpan data pengguna (id, name, email, password, role) |
| `products` | Menyimpan data produk (id, name, price, stock, description) |
| `orders` | Menyimpan data transaksi pemesanan (id, user_id, product_id, quantity, total_price, status) |
| `cart` | Menyimpan daftar belanja pengguna sebelum checkout |
| `payment` | Menyimpan informasi pembayaran pesanan |
| `shipping` | Menyimpan informasi pengiriman barang |

Dalam sistem monolitik, semua tabel ini berada dalam **satu database**, sehingga layanan yang berbeda **bergantung langsung** pada satu sumber data. Hal ini dapat menimbulkan masalah seperti kesulitan dalam penskalaan dan pemeliharaan.

####  **2. Dekomposisi Database ke Microservices**

Setelah beralih ke **arsitektur microservices**, saya memecah tabel-tabel tersebut berdasarkan fungsinya masing-masing. Berikut adalah rinciannya:

##### **➡️ Auth Service (Layanan Autentikasi)**
- **Fungsi:** Menyimpan data pengguna.
- **Tabel yang dipertahankan:**  
  - `users`

##### **➡️ Product Service (Layanan Produk)**
- **Fungsi:** Menyimpan data produk.
- **Tabel yang dipertahankan:**  
  - `products`

##### **➡️ Order Service (Layanan Pesanan)**  
- **Fungsi:** Mengelola pemesanan dan transaksi.
- **Tabel yang dipertahankan:**  
  - `orders`  
  - `cart`  
  - `payment`  
  - `shipping`  

#### **3. Perubahan Skema Database**

Setiap layanan akan memiliki database masing-masing. Berikut contoh perubahan skema yang dilakukan:

##### **1️⃣ Auth Service Database**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(50)
);
```
![Dekomposing database setiap service](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png)

--- 

## **KESIMPULAN**
Kesimpulan dari hasil migrasi aplikasi yang memiliki arsitektur monolith kemudian dirubah menjadi arsitektur microservice berhasil berjalan dengan lancar. Implementasi ini mencakup pembagian sistem menjadi empat layanan utama, yaitu Auth Service, Product Service, Order Service, dan Gateway Service. Setiap layanan telah dikonfigurasi secara independen dengan pengaturan yang sesuai, termasuk konfigurasi database, API, dan komunikasi antar layanan. 

Dengan arsitektur microservices, sistem ini menjadi lebih modular, mudah dikelola, dan siap untuk dikembangkan lebih lanjut di masa depan. Keuntungan utama dari pendekatan ini adalah kemudahan dalam penskalaan, pemeliharaan, dan pengembangan fitur baru tanpa mengganggu layanan lainnya. Selain itu, penggunaan API Gateway memastikan bahwa komunikasi antar layanan terpusat dan terorganisir dengan baik.

Secara keseluruhan, implementasi ini telah mencapai tujuan yang diharapkan, yaitu membangun sistem yang lebih fleksibel dan siap menghadapi kebutuhan pengembangan di masa depan. Langkah selanjutnya adalah melakukan optimasi lebih lanjut, seperti meningkatkan keamanan API, mengimplementasikan autentikasi yang lebih robust, dan memastikan ketersediaan sistem dengan menggunakan teknologi containerisasi seperti Docker.


