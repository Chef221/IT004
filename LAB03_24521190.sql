----------------------- LAB03 -----------------------------------
-- Bài tập 1: Sinh viên hoàn thành Phần III bài tập QuanLyBanHang câu 12 và câu 13.
-- 12.	Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
UNION
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20
-- 13.	Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

-- Bài tập 2: Sinh viên hoàn thành Phần II bài tập QuanLyGiaoVu từ câu 1 đến câu 4.
-- 1.	Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (
	SELECT TRGKHOA FROM KHOA
)
-- 2.Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HV
SET HV.DIEMTB = (
	SELECT AVG(KQT.DIEM * 1.0)
	FROM KETQUATHI KQT
	WHERE KQT.MAHV = HV.MAHV 
	AND KQT.LANTHI = (
		SELECT MAX(LANTHI)
		FROM KETQUATHI
		WHERE MAHV = HV.MAHV AND MAMH = KQT.MAMH
	)
)
FROM HOCVIEN HV
-- 3.	Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (
	SELECT MAHV
	FROM KETQUATHI
	WHERE LANTHI = 3 AND DIEM < 5
)
-- 4.	Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
UPDATE HOCVIEN 
SET XEPLOAI = CASE 
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB >= 8 THEN 'G'
	WHEN DIEMTB >= 6.5 THEN 'K'
	WHEN DIEMTB >= 5 THEN 'TB'
	ELSE 'Y'
END

-- Bài tập 3: Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 6 đến câu 10.
-- 6.Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT MH.TENMH
FROM GIANGDAY GD 
INNER JOIN GIAOVIEN GV ON GD.MAGV = GD.MAGV
INNER JOIN MONHOC MH ON MH.MAMH = GD.MAMH
WHERE GV.HOTEN = 'Tran Tam Thanh' AND  GD.HOCKY = 1 AND GD.NAM = 2006
-- 7.Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MH.MAMH, MH.TENMH
FROM GIANGDAY GD
INNER JOIN LOP L ON L.MAGVCN = GD.MAGV
INNER JOIN MONHOC MH ON MH.MAMH = GD.MAMH
WHERE L.MALOP = 'K11' AND GD.HOCKY = 1 AND GD.NAM = 2006
-- 8.Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HV.HO + ' ' + HV.TEN AS HOTEN
FROM LOP L INNER JOIN HOCVIEN HV ON L.TRGLOP = HV.MAHV
WHERE L.MALOP IN (
	SELECT GD.MALOP
	FROM GIANGDAY GD
	INNER JOIN GIAOVIEN GV ON GD.MAGV = GV.MAGV
	INNER JOIN MONHOC MH ON GD.MAMH = MH.MAMH
	WHERE GV.HOTEN = 'Nguyen To Lan' AND MH.TENMH = 'Co So Du Lieu'
) 
-- 9.In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH
WHERE MH.MAMH IN (
SELECT DK.MAMH_TRUOC
FROM DIEUKIEN DK
WHERE DK.MAMH = (
	SELECT MAMH
	FROM MONHOC
	WHERE TENMH = 'Co So Du Lieu'
))
-- 10.Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH
WHERE MH.MAMH IN (
SELECT DK.MAMH	
FROM DIEUKIEN DK
WHERE DK.MAMH_TRUOC = (
	SELECT MAMH
	FROM MONHOC 
	WHERE TENMH = 'Cau Truc Roi Rac'
))

-- Bài tập 4: Sinh viên hoàn thành Phần III bài tập QuanLyBanHang từ câu 14 đến 18.
-- 14.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT SP.MASP, SP.TENSP
FROM CTHD CT 
INNER JOIN SANPHAM SP ON CT.MASP = SP.MASP
INNER JOIN HOADON HD ON HD.SOHD = CT.SOHD
WHERE SP.NUOCSX = 'Trung Quoc' OR HD.NGHD = '1/1/2007'
-- 15.In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT 
SELECT CTHD.MASP, SP.TENSP
FROM CTHD INNER JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
-- 16.In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT MASP, TENSP 
FROM SANPHAM
EXCEPT 
SELECT CTHD.MASP, SP.TENSP
FROM CTHD INNER JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
INNER JOIN HOADON HD ON HD.SOHD = CTHD.SOHD
WHERE YEAR(HD.NGHD) = 2006
-- 17.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
EXCEPT
SELECT CTHD.MASP, SP.TENSP
FROM CTHD INNER JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
INNER JOIN HOADON HD ON HD.SOHD = CTHD.SOHD
WHERE SP.NUOCSX = 'Trung Quoc' AND YEAR(HD.NGHD) = 2006
-- 18.Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT CT.SOHD
FROM CTHD CT INNER JOIN SANPHAM SP ON CT.MASP = SP.MASP
INNER JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE NUOCSX = 'Singapore' AND YEAR(HD.NGHD) = 2006
GROUP BY CT.SOHD
HAVING COUNT(DISTINCT SP.MASP) >= (
	SELECT COUNT(MASP)
	FROM SANPHAM
	WHERE NUOCSX = 'Singapore'
)

-- Bài tập 5: Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 11 đến câu 18.
-- 11.Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT GV.HOTEN
FROM GIANGDAY GD INNER JOIN GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE GD.MAMH = 'CTRR' AND GD.MALOP = 'K11' AND GD.HOCKY = 1 AND GD.NAM = 2006
INTERSECT
SELECT GV.HOTEN
FROM GIANGDAY GD INNER JOIN GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE GD.MAMH = 'CTRR' AND GD.MALOP = 'K12' AND GD.HOCKY = 1 AND GD.NAM = 2006
-- 13.Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (
	SELECT MAGV 
	FROM GIANGDAY
)
-- 14.Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT G.MAGV, G.HOTEN
FROM GIAOVIEN G
WHERE NOT EXISTS (
	SELECT 1
	FROM GIANGDAY GD
	INNER JOIN MONHOC MH ON GD.MAMH = MH.MAMH
	WHERE GD.MAGV = G.MAGV AND MH.MAKHOA = G.MAKHOA
)
-- 15.Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN HV
WHERE HV.MALOP = 'K11' 
AND (
	EXISTS (
		SELECT 1 
		FROM KETQUATHI KQT
		WHERE KQT.MAHV = HV.MAHV AND KQT.KQUA = 'Khong dat'
		GROUP BY KQT.MAMH
		HAVING COUNT(*) > 3
	)
	OR 
	EXISTS (
		SELECT 1 
		FROM KETQUATHI KQT
		WHERE KQT.MAHV = HV.MAHV
		AND KQT.MAMH = 'CTRR'
		AND KQT.LANTHI = 2
		AND KQT.DIEM = 5
	)
)
-- 16.Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN (
	SELECT MAGV
	FROM GIANGDAY
	WHERE MAMH = 'CTRR' 
	GROUP BY MAGV, HOCKY, NAM
	HAVING COUNT(DISTINCT MALOP) >= 2
)
-- 17.Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN, KQT.DIEM
FROM HOCVIEN HV INNER JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV
WHERE KQT.MAMH = 'CSDL' AND KQT.LANTHI = (
	SELECT MAX(LANTHI)
	FROM KETQUATHI
	WHERE MAHV = HV.MAHV AND MAMH = 'CSDL'
)		
-- 18.Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN, KQT.DIEM
FROM HOCVIEN HV INNER JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV
INNER JOIN MONHOC MH ON MH.MAMH = KQT.MAMH
WHERE MH.TENMH = 'Co So Du Lieu' AND KQT.DIEM = (
	SELECT MAX(DIEM)
	FROM KETQUATHI INNER JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
	WHERE MAHV = HV.MAHV AND TENMH = 'Co So Du Lieu'
)