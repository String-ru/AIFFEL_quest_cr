# AIFFEL Campus Online Code Peer Review Templete
- 코더 : 류지호, 천주호
- 리뷰어 : 안진용, 공옥례

# 코더 회고
류지호: LSTM 인코더–디코더와 어텐션의 원리와 성능을 경험하면서, transformer를 빨리 활용해보고 싶어졌습니다.
토크나이저의 OOV·시작·종료 토큰 처리가 학습 안정성과 요약 품질에 미치는 영향이 인상 깊었습니다.

천주호: seq2seq 구동 방식을 이해하고 직접 요약을 하는 머신러닝 모델을 구축해봐서 좋았습니다. 
앞으로 사용하진 않겠지만 이해하고 적용하는것과는 차이가 클것같아요. 더많은 언어모델들을 사용하고 싶어졌습니다.

# 코드에 대한 설명

모델이 충분한 표현력을 가지면서도 학습 시간과 메모리 사용량을 적절히 균형 있게 유지하도록 latent_dim=256으로 설정.

GPU 메모리 한계와 과적합 방지를 고려해 초기 실험에서 안정적인 수렴을 보인 설정 그대로 batch_size=64, epochs=15 사용.

<OOV> 및 시작(sostoken)/종료(eostoken) 토큰을 추가하여 디코더가 미등록 단어를 처리하고 문장 생성의 시작·종료 지점을 명시적으로 학습하게 함.

# PRT(Peer Review Template)

🤔 피어리뷰 템플릿

- [x]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요? (완성도)**
    - 문제에서 요구하는 최종 결과물이 첨부되었는지 확인
    - 문제를 해결하는 완성된 코드란 프로젝트 루브릭 3개 중 2개, 
    퀘스트 문제 요구조건 등을 지칭
        - 해당 조건을 만족하는 부분의 코드 및 결과물을 캡쳐하여 사진으로 첨부
          
        ![1](https://github.com/user-attachments/assets/68527b18-c789-4dbf-a951-77985d0ff8fa)
        ![2](https://github.com/user-attachments/assets/a31c9b4f-6222-44bb-8fcb-588fea2a1be0)


- [x]  **2. 프로젝트에서 핵심적인 부분에 대한 설명이 주석(닥스트링) 및 마크다운 형태로 잘 기록되어있나요? (설명)**
    - [x]  모델 선정 이유
    - [x]  하이퍼 파라미터 선정 이유
    - [x]  데이터 전처리 이유 또는 방법 설명

        ![4](https://github.com/user-attachments/assets/59c34702-15e5-4715-b59b-6eb2b1de1b15)

           
- [x]  **3. 체크리스트에 해당하는 항목들을 수행하였나요? (문제 해결)**
    - [x]  데이터를 분할하여 프로젝트를 진행했나요? (train, validation, test 데이터로 구분)
    - [x]  하이퍼파라미터를 변경해가며 여러 시도를 했나요? (learning rate, dropout rate, unit, batch size, epoch 등)
    - [x]  각 실험을 시각화하여 비교하였나요?
    - [x]  모든 실험 결과가 기록되었나요?

        ![3](https://github.com/user-attachments/assets/437b176f-ff1d-4cd0-ab6d-1ce7980c5689)


- [x]  **4. 프로젝트에 대한 회고가 상세히 기록 되어 있나요? (회고, 정리)**
    - [x]  배운 점
    - [x]  아쉬운 점
    - [x]  느낀 점
    - [x]  어려웠던 점

        ![5](https://github.com/user-attachments/assets/9a690c6b-5271-459b-9208-23be483d8a1e)

        
- [ ]  **5.  앱으로 구현하였나요?**
    - [ ]  구현된 앱이 잘 동작한다.
    - [ ]  모델이 잘 동작한다.


# 회고(참고 링크 및 코드 개선)
```
# 코랩 gpu만 더 있었어도,, 아쉬웠을꺼 같습니다,, 정리 깔끔하게 하셔서 보기에 편했습니다 수고하셧습니다! 
