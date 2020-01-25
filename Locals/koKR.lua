local ADDON_NAME, ADDON = ...

if (GetLocale() ~= "koKR") then
    return
end

local L = ADDON.L or {}

L["Are you sure that you want to delete this Contact?"] = "이 연락처를 삭제 하시겠습니까?"
L["Button scale factor set to %d"] = "연락처 버튼의 크기를 설정 - %d"
L["ClickToSend mode disabled"] = "주소록 클릭시 바로 보냄 기능 - 꺼짐"
L["ClickToSend mode enabled"] = "주소록 클릭시 바로 보냄 기능 - 켜짐"
L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "주소록 추가됨 (위치: %d, 수신자: %s, 아이콘: %s)"
L["Contact Name:"] = "캐릭터 이름:"
L["Contact Note:"] = "메모:"
L["Contact removed (Position: %d)"] = "주소록 삭제됨 (위치: %d)"
L["Create"] = "만들기"
L["No Contact on position %d"] = "해당 위치에 주소록 없음 - %d"
L["Note changed to %s (Position: %d)"] = "메모 변경됨 - %s (위치: %d)"
L["Note removed (Position: %d)"] = "메모 삭제됨 (위치: %d)"
L["Position set to %s"] = "위치 설정됨 - %s"
L["Size changed to %dx%d"] = "크기 변경됨 - %dx%d"

-- Settings
L["SETTING_CLICKTOSEND_LABEL"] = "주소록 클릭시 바로 우편 발송"
L["SETTING_COLUMN_COUNT_LABEL"] = "몇 칸을 사용할지"
L["SETTING_HEAD_DISPLAY"] = "연락처 화면 설정"
L["SETTING_HEAD_INTERACTION"] = "상호 작용"
L["SETTING_POSITION_BOTTOM"] = "아래"
L["SETTING_POSITION_LABEL"] = "주소록을 우편함 창의 어느쪽에 위치"
L["SETTING_POSITION_LEFT"] = "왼쪽"
L["SETTING_POSITION_RIGHT"] = "오른쪽"
L["SETTING_POSITION_TOP"] = "위"
L["SETTING_ROW_COUNT_LABEL"] = "몇 줄을 사용할지"
L["SETTING_SCALE_AUTO"] = "자동"
L["SETTING_SCALE_LABEL"] = "크기 조절"
L["SETTING_SCALE_MANUAL"] = "직접 입력"
