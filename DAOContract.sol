pragma solidity ^0.4.11;

// Интерфейс токена
interface ChangableToken {
    function stop();
    function start();
    function balanceOf(address user) returns (uint256);
	function transfer(address _receiver, uint256 _amount);
}

// Контракт ДАО
contract DAOContract {


	// Переменная для хранения владельца контракта
    address public owner;

    // Переменная для хранения токена
    ChangableToken public token;

    // Минимальное число голосов
    uint public minVotes;

	
	
	// Объявляем переменную для стомости токена
    uint public buyPrice = 10000;
	
    // Переменная для предложенной цены
    uint public proposalPrice;

    // Переменная для хранения состояния голосования
    bool public voteActive = false;

    // Стукрутра для голосов
    struct Votes {
        int current;
        uint numberOfVotes;
    }

    // Переменная для структуры голосов
    Votes public election;

    // Функция инициализации ( принимает адрес токена)
    function DAOContract(ChangableToken _token){
		owner = msg.sender;
        setToken(_token);
    }


    // Фукнция для предложения нового имени
    function newPrice(uint _newPrice) public {
        // Проверяем, что голосование не идет сейчас
        require(!voteActive);
        proposalPrice = _newPrice;
        voteActive = true;

        // Остановка работы токена
        token.stop();
    }

    // Функция для голосования
    function vote(bool _vote) public {
        // Проверяем, что голосование идет
        require(voteActive);
        // Логика для голосования
        if (_vote){
            election.current += int(token.balanceOf(msg.sender));
        }
        else {
            election.current -= int(token.balanceOf(msg.sender));
        }

        election.numberOfVotes += token.balanceOf(msg.sender);

    }

    // Функция для смены символа
    function changePrice() public {
		
        // Проверяем, что голование активно		
        require(voteActive);
		
        // Проверяем, что получили достаточное количество голосов
        require(election.numberOfVotes >= minVotes);
		
        // Если собрали нужное число голосов, то обновляем цену
        if (election.current >= int256(minVotes) ){
            buyPrice = proposalPrice;
        }

        // Сбрасываем все переменные для голосования
        election.numberOfVotes = 0;
        election.current = 0;
		proposalPrice = 0;
        voteActive = false;

        // Возобновляем работу токена
        token.start();
    }	
	
	// Изменить минимальное необходимое число голосов. Доступна только владельцу. Нужно для тестирования
	function changeMinVotes(uint _minVotes) {		
		require(owner == msg.sender);
		minVotes = _minVotes;
	}
	
	// Фунция смены токена. Доступна только владельцу. В целях тестирования
	function setToken(ChangableToken _token) public { 
		require(owner == msg.sender);
		token = _token;
	}
	
	
	// ПОКУПКА
	
	// Функция для прямой отправки эфиров на контракт
    function () payable {
        _buy(msg.sender, msg.value);
    }

    // Вызываемая функция для отправки эфиров на контракт, возвращающая количество купленных токенов
    function buy() payable returns (uint){
        // Получаем число купленных токенов
        uint tokens = _buy(msg.sender, msg.value);
        // Возвращаем значение
        return tokens;
    }

    // Внутренняя функция покупки токенов, возвращает число купленных токенов
    function _buy(address _sender, uint256 _amount) internal returns (uint){
		require(buyPrice > 0);
        // Рассчитываем стоимость
        uint tokens = _amount / buyPrice;
		if(tokens > 0) {
			// Отправляем токены с помощью вызова метода токена
			token.transfer(_sender, tokens);
			// Возвращаем значение
			return tokens;
		}
		return 0;
    }

}