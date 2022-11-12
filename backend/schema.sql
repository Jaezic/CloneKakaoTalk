create table User(
	ID varchar(30) primary key, -- ID 중복 불가 --
    PassWord text not null, -- 비밀번호 -- 
    Name text not null, -- 이름 --
    EMail text not null, -- 이메일 --
    Brithday int not null, -- 생일 --
    TellNum int,
    HomeAddress varchar(100) 
);

create table UserStatus(
	ID varchar(30) references User(ID),
    NickName text not null, -- 별명 (변경가능) --
    StatusMessage text, -- 상태 메시지 (변경가능) --
    ConnectionStatus text, -- 접속상태 online /+ offline --
    ResentlyConnectionTime int, -- 마지막 login 시간 --
    NumberOfLogins int, -- log in 한 횟수 --
    ResentlyLogOutTime int -- log out 시간 --
);

create table Friend_List(
	ID varchar(30) references User(ID), -- User의 ID 정보 --
    Friend_ID varchar(30) references User(ID), -- 친구의 ID 정보 --
    primary key(ID)
);