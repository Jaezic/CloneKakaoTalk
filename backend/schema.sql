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
    ResentlyLogOutTime int, -- log out 시간 --
    profile_image_id int,
    profile_background_id int
);

create table Friend_List(
	ID varchar(30) references User(ID), -- User의 ID 정보 --
    Friend_ID varchar(30) references User(ID), -- 친구의 ID 정보 --
    primary key(ID)
);

CREATE TABLE User_file (
    id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    fieldname VARCHAR(256),
    originalname VARCHAR(256),
    encoding VARCHAR(16),
    mimetype VARCHAR(64),
    destination VARCHAR(256),
    filename VARCHAR(256),
    path VARCHAR(256),
    size int,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES User(id) on delete cascade
);