﻿-- PHẦN 1 QUẢN LÝ BÁN HÀNG --
USE QuanLyBanHang
-- Phần III --
-- Câu 12 --
SELECT DISTINCT HOADON.SOHD 
FROM SANPHAM,HOADON,CTHD 
WHERE SANPHAM.MASP = CTHD.MASP AND HOADON.SOHD = CTHD.SOHD AND (SANPHAM.MASP = 'BB01' OR SANPHAM.MASP ='BB02') AND (SL >= 10 AND SL <= 20)
-- Câu 13 --
SELECT DISTINCT SOHD
FROM CTHD
WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT DISTINCT SOHD FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

-- Câu 14 --
SELECT DISTINCT SANPHAM.MASP , TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM SANPHAM,HOADON,CTHD
WHERE SANPHAM.MASP = CTHD.MASP AND HOADON.SOHD = CTHD.SOHD AND NGHD = '01/01/2007'

-- Câu 14 --
SELECT DISTINCT CTHD.MASP , SANPHAM.TENSP
FROM ((CTHD
INNER JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP)
INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD)
WHERE NGHD = '01/01/2007'
UNION
SELECT DISTINCT SANPHAM.MASP , TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

-- Câu 15 --
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM SANPHAM, CTHD
WHERE SANPHAM.MASP NOT IN (SELECT MASP FROM CTHD )

-- Câu 16 --
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM SANPHAM, HOADON
WHERE MASP NOT IN 
(
SELECT MASP FROM CTHD,HOADON WHERE HOADON.SOHD = CTHD.SOHD AND YEAR(NGHD) = '2006'
)
-- Câu 17 --
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
INTERSECT
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM SANPHAM, HOADON
WHERE MASP NOT IN
(
SELECT MASP FROM CTHD,HOADON WHERE HOADON.SOHD = CTHD.SOHD AND YEAR(NGHD) = '2006'
)

-- Câu 18 --
SELECT SOHD
FROM HOADON
WHERE NOT EXISTS
(
	SELECT *
	FROM SANPHAM
	WHERE NUOCSX = 'Singapore'
	AND NOT EXISTS
	(
		SELECT *
		FROM CTHD
		WHERE CTHD.SOHD = HOADON.SOHD
		AND CTHD.MASP = SANPHAM.MASP
	)
)
-- PHẦN 2 QUẢN LÝ GIÁO VỤ --
USE QuanLyGiaoVu
-- Phần II --
-- Câu 1 --
UPDATE GIAOVIEN  SET HESO = HESO*1.2
WHERE GIAOVIEN.MAGV IN (SELECT KHOA.TRGKHOA FROM KHOA)
-- Câu 2 -- 
UPDATE HOCVIEN
SET DIEMTB = (
				SELECT AVG(DIEM)
                FROM KETQUATHI K1
                WHERE LANTHI = (SELECT MAX(LANTHI)
                                FROM KETQUATHI K2
                                WHERE (K1.MAHV = K2.MAHV AND K1.MAMH = K2.MAMH)
                                GROUP BY MAHV,MAMH)
                GROUP BY MAHV
                HAVING MAHV = HOCVIEN.MAHV
			)
SELECT * FROM HOCVIEN
-- Câu 3 --

UPDATE HOCVIEN
SET GHICHU = 'Cam thi' 
WHERE MAHV IN (
SELECT MAHV FROM KETQUATHI WHERE LANTHI = '3' AND DIEM < 5
)

-- Câu 4 --
UPDATE HOCVIEN
SET XEPLOAI = 'XS'
WHERE DIEMTB >= 9

UPDATE HOCVIEN
SET XEPLOAI = 'G'
WHERE DIEMTB >= 8 AND DIEMTB < 9

UPDATE HOCVIEN
SET XEPLOAI = 'K'
WHERE DIEMTB >= 6.5 AND DIEMTB <8

UPDATE HOCVIEN
SET XEPLOAI = 'TB'
WHERE DIEMTB >= 5 AND DIEMTB < 6.5

UPDATE HOCVIEN
SET XEPLOAI = 'Y'
WHERE DIEMTB < 5

-- Phần III --

-- Câu 6 -- 
SELECT DISTINCT MONHOC.TENMH
FROM GIAOVIEN, GIANGDAY, MONHOC
WHERE GIANGDAY.MAMH = MONHOC.MAMH AND GIAOVIEN.MAGV = GIANGDAY.MAGV AND GIANGDAY.HOCKY = '1' AND GIAOVIEN.HOTEN = 'Tran Tam Thanh' AND GIANGDAY.NAM = '2006'

-- Câu 7 --
SELECT MONHOC.MAMH, TENMH
FROM GIANGDAY, LOP, MONHOC
WHERE GIANGDAY.MAMH = MONHOC.MAMH AND LOP.MAGVCN = GIANGDAY.MAGV AND GIANGDAY.NAM = '2006' AND GIANGDAY.HOCKY = '1' AND LOP.MALOP = 'K11'

-- Câu 8 --
SELECT DISTINCT HOCVIEN.HO, HOCVIEN.TEN
FROM LOP, HOCVIEN, GIAOVIEN , MONHOC , GIANGDAY
WHERE LOP.MALOP = GIANGDAY.MALOP 
		AND GIANGDAY.MAGV = GIAOVIEN.MAGV 
		AND MONHOC.MAMH = GIANGDAY.MAMH 
		AND LOP.TRGLOP = HOCVIEN.MAHV 
		AND MONHOC.TENMH = 'Co So Du Lieu' AND GIAOVIEN.HOTEN = 'Nguyen To Lan' 

-- Câu 9 --
SELECT DIEUKIEN.MAMH_TRUOC, TENMH 
FROM MONHOC, DIEUKIEN
WHERE DIEUKIEN.MAMH in (SELECT MAMH FROM MONHOC WHERE TENMH='Co So Du Lieu')
and DIEUKIEN.MAMH_TRUOC=MONHOC.MAMH 
-- Câu 10 --
SELECT MONHOC.MAMH, TENMH
FROM MONHOC, DIEUKIEN
WHERE DIEUKIEN.MAMH_TRUOC IN (SELECT MAMH FROM MONHOC WHERE TENMH = 'Cau Truc Roi Rac')
AND MONHOC.MAMH = DIEUKIEN.MAMH

-- Câu 11 --
SELECT HOTEN
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
AND GIANGDAY.MALOP = 'K11'
AND GIANGDAY.MAMH = 'CTRR'
AND GIANGDAY.HOCKY = '1' AND GIANGDAY.NAM = '2006'
INTERSECT
(
SELECT HOTEN
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
AND GIANGDAY.MALOP = 'K12'
AND GIANGDAY.MAMH = 'CTRR'
AND GIANGDAY.HOCKY = '1' AND GIANGDAY.NAM = '2006'
)
-- Câu 12 --
SELECT
	HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM
	HOCVIEN, KETQUATHI
WHERE
	HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MAMH = 'CSDL' AND LANTHI = 1 AND KQUA = 'Khong Dat'
	AND NOT EXISTS (SELECT * FROM KETQUATHI WHERE LANTHI > 1 AND KETQUATHI.MAHV = HOCVIEN.MAHV)
-- Câu 13 --
SELECT GIAOVIEN.MAGV , GIAOVIEN.HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT MAGV FROM GIANGDAY)

-- Câu 14 --
SELECT GIAOVIEN.MAGV , GIAOVIEN.HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT GIAOVIEN.MAGV FROM GIANGDAY, GIAOVIEN, MONHOC 
							   WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV 
							   AND MONHOC.MAKHOA = GIAOVIEN.MAKHOA
							   AND GIANGDAY.MAMH = MONHOC.MAMH)
-- Câu 15 --
SELECT DISTINCT HOCVIEN.HO , HOCVIEN.TEN
FROM
	HOCVIEN, KETQUATHI
WHERE
	HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MALOP = 'K11'
	AND ((LANTHI = 2 AND DIEM = 5)
	OR HOCVIEN.MAHV IN
	(
		SELECT DISTINCT MAHV
		FROM KETQUATHI
		WHERE KQUA = 'Khong Dat'
		GROUP BY MAHV, MAMH
		HAVING COUNT(LANTHI) > 3	
	))

-- Câu 16 --
SELECT HOTEN
FROM
	GIAOVIEN, GIANGDAY
WHERE
	GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND MAMH = 'CTRR'
GROUP BY 
	GIAOVIEN.MAGV, HOTEN, HOCKY
HAVING 
	COUNT(GIANGDAY.MALOP) >= 2
-- Câu 17 --
SELECT HOCVIEN.*, DIEM AS 'DIEM CUOI CUNG'
FROM KETQUATHI, HOCVIEN
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
	AND MAMH = 'CSDL'
	AND LANTHI = (
	SELECT MAX(LANTHI)
	FROM KETQUATHI
	WHERE MAMH = 'CSDL' AND KETQUATHI.MAHV = HOCVIEN.MAHV
	GROUP BY MAHV
	)
-- Câu 18 --
SELECT HOCVIEN.*, DIEM AS 'DIEM CAO NHAT'
FROM KETQUATHI, HOCVIEN, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
	AND MONHOC.MAMH = KETQUATHI.MAMH
	AND MONHOC.TENMH = 'Co So Du Lieu'
	AND DIEM = (
	SELECT MAX(DIEM)
	FROM KETQUATHI, MONHOC
	WHERE TENMH = 'Co So Du Lieu' AND KETQUATHI.MAHV = HOCVIEN.MAHV AND MONHOC.MAMH = KETQUATHI.MAMH
	GROUP BY MAHV
	)