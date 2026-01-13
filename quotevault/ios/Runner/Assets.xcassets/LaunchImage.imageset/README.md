# 📖 QuoteVault — AI-Built Quote Discovery App

QuoteVault is a full-featured quote discovery, personalization, and collection app built with **Flutter** and **Supabase**.  
It supports user accounts, daily quotes, favorites, collections, cloud sync, and visual personalization.

This project was developed using a **modern AI-assisted engineering workflow**, where **ChatGPT (Ask Mode in browser)** was used as the primary development tool to design, debug, and implement all features.

---

# 🧠 What This Project Demonstrates

QuoteVault is not only a mobile app — it is also a demonstration of how **AI-assisted development** can dramatically accelerate product delivery.

The focus is:
- Using AI to write production-grade Flutter code
- Using AI to design Supabase schemas & security
- Using AI to debug UI, state, and async issues
- Using AI to reason about architecture

Everything in this app was created through iterative conversations with **ChatGPT Ask Mode**.

---

# 🚀 Feature Coverage

## 1️⃣ Authentication & User Accounts (Supabase Auth)
- Sign up with email & password
- Login & logout
- Password reset via email
- User profile screen (name, avatar)
- Session persistence (user stays logged in after app restart)

---

## 2️⃣ Quote Browsing & Discovery
- Infinite scrolling home feed
- Browse by category:
    - Motivation
    - Love
    - Success
    - Wisdom
    - Humor
- Search quotes by keyword
- Search by author
- Pull-to-refresh
- Loading & empty states
- Server-driven **Quote of the Day**

---

## 3️⃣ Favorites & Collections
- Save quotes to favorites
- View all favorites
- Create custom collections
- Add/remove quotes from collections
- All favorites & collections are cloud-synced across devices

---

## 4️⃣ Daily Quote (Server-Controlled)
- Quote of the Day stored in Supabase
- Changes once per day via database cron job
- Same daily quote across all devices & users

---

## 5️⃣ Sharing
- Share quote as text
- Share quote as styled card
- Save quote card as image

---

## 6️⃣ Personalization & Settings
- Light & Dark mode
- Accent color themes
- Font size control
- All settings persist locally
- Settings also sync to Supabase profile

---

# 🛠 Tech Stack

| Layer | Technology |
|------|-----------|
| UI | Flutter (Material 3) |
| State | Provider |
| Auth | Supabase Auth |
| Database | Supabase Postgres |
| Storage | Supabase Storage |
| Preferences | SharedPreferences |
| Fonts | Google Fonts |
| Daily Quote | Supabase Cron Job |

---

# ⚙️ Setup Instructions

## 1️⃣ Create Supabase Project
Go to https://supabase.com and create a new project.

Enable:
- Email authentication
- Database
- Storage

---

## 2️⃣ Database Schema

Run this in Supabase SQL Editor:

```sql
create table quotes (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  author text,
  category text
);

create table profiles (
  id uuid primary key references auth.users,
  name text,
  avatar_url text,
  theme text,
  accent_color text,
  font_size int
);

create table favorites (
  user_id uuid references auth.users,
  quote_id uuid references quotes,
  primary key (user_id, quote_id)
);

create table collections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users,
  name text
);

create table collection_quotes (
  collection_id uuid references collections,
  quote_id uuid references quotes,
  primary key (collection_id, quote_id)
);

create table daily_quotes (
  day date primary key,
  quote_id uuid references quotes
);
