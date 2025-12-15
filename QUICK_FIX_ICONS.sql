-- QUICK FIX: Update Services Icon Type to 'image'
-- Copy dan paste ke Supabase SQL Editor, lalu RUN

-- Fix icon_type dari 'icon' ke 'image'
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'HOME_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'FLOOR_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'WINDOW_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'ROOM_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'CLOTHES_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'CARPET_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'TOILET_CLEAN';
UPDATE services SET icon_type = 'image', updated_at = NOW() WHERE code = 'GARDEN_CLEAN';

-- Fix typo: toliet.png -> toilet.png
UPDATE services SET icon_path = 'toilet.png', icon_type = 'image', updated_at = NOW() WHERE code = 'TOILET_CLEAN';

-- Fix typo: clothe.png -> clothes.png
UPDATE services SET icon_path = 'clothes.png', icon_type = 'image', updated_at = NOW() WHERE code = 'CLOTHES_CLEAN';

-- Fix: home.png -> home-icon.png (sesuai nama file di folder images/)
UPDATE services SET icon_path = 'home-icon.png', icon_type = 'image', updated_at = NOW() WHERE code = 'HOME_CLEAN';

-- Verify hasil update
SELECT code, name, icon_path, icon_type FROM services ORDER BY display_order;

-- Expected output:
-- HOME_CLEAN     | Home Cleaning     | home-icon.png | image
-- FLOOR_CLEAN    | Floor Cleaning    | floor.png     | image
-- WINDOW_CLEAN   | Window Cleaning   | window.png    | image
-- ROOM_CLEAN     | Room Cleaning     | office.png    | image
-- CLOTHES_CLEAN  | Clothes Cleaning  | clothes.png   | image
-- CARPET_CLEAN   | Carpet Cleaning   | carpet.png    | image
-- TOILET_CLEAN   | Toilet Cleaning   | toilet.png    | image
-- GARDEN_CLEAN   | Garden Cleaning   | garden.png    | image
