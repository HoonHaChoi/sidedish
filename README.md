# 온라인 반찬 서비스

- 기간 : 2021.04 - 2021.04
- 사용 언어 : Swift

- 개발 인원: iOS(2명)
- 기여도 : 70%

- 관련 기술: UICollectionViewDiffableDataSource, Combine

## 프로그래밍 요구사항
상품정보 셀에는 상품 이지미, 상품 이름, 상세 설명 , 상품 가격 , 이벤트 배지를 표시<br>
상세화면 상단에는 스크롤뷰를 사용하며 Page 방식을 표시하고 좌우로 스크롤 하며 이미지를 변경<br>
상품 정보 아래에 상품 상세 설명 이미지를 세로로 이어서 붙임, 위 아래로 스크롤이 가능<br>
주문하기 버튼을 누르면 해당 상품에 대한 주문을 요청하고 성공하면 이전화면으로 이동<br>

### 앱 주요 기능

```
- 종류별(메인음식, 국, 반찬) 반찬 리스트  
- 반찬 상세 화면
- (메인음식, 국, 반찬 목록,이미지) 다중 비동기 네트워크 요청
- Oauth를 활용한 로그인
```



### 


### 앱 구성

<img width="400" alt="스크린샷 2021-05-01 오후 10 35 24" src="https://user-images.githubusercontent.com/33626693/116784144-9df48f00-aacd-11eb-9869-ad74746e876f.png"> 

<img width="400" alt="스크린샷 2021-05-01 오후 10 35 49" src="https://user-images.githubusercontent.com/33626693/116784142-9af99e80-aacd-11eb-87b8-95f6e3920b69.png"> 


### 앱 시연화면

| <img width="285" alt="스크린샷 2021-11-24 오후 6 58 07" src="https://user-images.githubusercontent.com/33626693/143216391-af4ee5db-87d9-45eb-9ec8-442f34d25c10.png"> | <img width="283" alt="스크린샷 2021-11-24 오후 6 58 35" src="https://user-images.githubusercontent.com/33626693/143216453-e2c50fce-a7b6-4221-9ca6-407db4ca1894.png"> | <img width="278" alt="스크린샷 2021-11-24 오후 6 58 52" src="https://user-images.githubusercontent.com/33626693/143216500-dfae74a3-5f12-4a31-a5fa-f01925c7fbff.png"> | <img width="282" alt="스크린샷 2021-11-24 오후 6 59 02" src="https://user-images.githubusercontent.com/33626693/143216541-812c7a70-d5c2-4dc4-b746-ec1a01e51080.png"> |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |

---

| ![ezgif com-video-to-gif-13](https://user-images.githubusercontent.com/33626693/116782017-aa72ea80-aac1-11eb-902f-9a952216b5b4.gif) | ![ezgif com-video-to-gif-14](https://user-images.githubusercontent.com/33626693/116782099-371da880-aac2-11eb-9e51-1ca0b021acd2.gif) | ![ezgif com-video-to-gif-15](https://user-images.githubusercontent.com/33626693/116783361-4e13c900-aac9-11eb-9cc6-9b0ffd0848db.gif) |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                           메인화면                           |                           상세화면                           |                            로그인                            |




## 프로젝트 만들면서 이슈사항

#### 문제 

- 앱 새로 시작했을때 이미지 순서가 올바르게 불러오지 못하는 상황이 발생

- 캐시 저장 후엔 정상적으로 이미지 순서대로 불러옴

- 코드 흐름 문제로 스택뷰에 이미지를 넣는 과정에서 백그라운드 스레드를 이용한다고 크러쉬 발생

#### 해결방안

이미지 URL 개수 만큼 UIImageView를 미리 생성 후

스택뷰에 저장

그 후 네트워크 요청을 통해 받은 데이터로 이미지뷰에 이미지 삽입

그 후 UIImage 의 size값을 통해 비율값 처리 하도록 함으로

이미지 순서에 맞게 들어가도록 처리가 되었음

이전 sideDish Detail 이미지 로드 하는 코드

```swift
ImageLoader().imageLoad(urlString: imageURL) { [unowned self] (uiimage) in
                guard let uiImage = uiimage else {
                    return
                }
                let imageView = UIImageView(image: uiImage)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                DispatchQueue.main.async {
                    print("섹셔 객체", imageView)
                self.detailSectionStackView.addArrangedSubview(imageView)
                let ratio = imageView.frame.height / imageView.frame.width
                if !(ratio.isNaN) {
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
                }
                }
            }
```

현재 sideDish Detail 이미지 로드 하는 코드
```swift
desctionImage.forEach { [weak self] (imageURL) in
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self?.detailSectionStackView.addArrangedSubview(imageView)
            
            ImageLoader().imageLoad(urlString: imageURL) { (uiImage) in
                guard let uiimage = uiImage else {
                    return
                }
                imageView.image = uiImage
                let ratio = uiimage.size.height / uiimage.size.width
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
            }
        }
```
