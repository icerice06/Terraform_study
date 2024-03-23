# Terraform_study
aws  terraform 공부

* CIDR 블록 10.0.0.0/16을 가진 simple_vpc라는 VPC생성
* 서로 다른 가용 영역(ap-northeast-2a 및 ap-northeast-2b)에 있는 두 개의 퍼블릭 서브넷(public_subnet1 및 public_subnet2)으로 각각 10.0.0.0/24 및 10.0.1.0/24의 CIDR 블록을 가집니다.
* VPC에 연결된 인터넷 게이트웨이(IGW).
* public_subnet1에 연결된 NAT 게이트웨이(nat_gateway).
* 서로 다른 가용 영역(ap-northeast-2a 및 ap-northeast-2b)에 있는 두 개의 프라이빗 서브넷(private_subnet1 및 private_subnet2)으로 각각 10.0.2.0/24 및 10.0.3.0/24의 CIDR 블록을 가집니다.
* 공용 및 사설 서브넷에 각각 연결된 라우팅 테이블(public_rt 및 private_rt).
* SSH(포트 22) 및 HTTP(포트 80) 트래픽을 허용하는 보안 그룹(hello).
* 특정 AMI, 인스턴스 유형, 보안 그룹 및 사용자 데이터 스크립트로 public_subnet1에 시작된 EC2 인스턴스에서 html hello 출력.
  
