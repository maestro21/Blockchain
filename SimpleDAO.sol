// Указываем версию для компилятора
pragma solidity ^0.4.11;


// Инициализация контракта
contract SimpleDAO2 {

    // Объявляем переменную в которой будет название токена
    string public name;
    // Объявляем переменную в которой будет символ токена
    string public symbol;
    // Объявляем переменную в которой будет число нулей токена
    uint8 public decimals;

    // Объявляем переменную в которой будет храниться общее число токенов
    uint256 public totalSupply;

    // Объявляем маппинг для хранения балансов пользователей
    mapping (address => uint256) public balanceOf;
    // Объявляем маппинг для хранения одобренных транзакций
    mapping (address => mapping (address => uint256)) public allowance;


	uint256 public price = 10000;
	
    // Функциональность для DAO

    uint8 public minVotes = 6;

    uint256 public proposalPrice;

    bool public voteActive = false;

    struct Votes {
        int current;
        uint numberOfVotes;
    }

	mapping(address => bool) internal voted;
	
    Votes public election;

    // --- Функциональность для DAO

    // Объявляем эвент для логгирования события перевода токенов
    event Transfer(address indexed from, address indexed to, uint256 value);
    // Объявляем эвент для логгирования события одобрения перевода токенов
    event Approval(address indexed from, address indexed to, uint256 value);

    // Функция инициализации контракта
    function SimpleDAO2() public{
        // Указываем число нулей
        decimals = 0;
        // Объявляем общее число токенов, которое будет создано при инициализации
        totalSupply = 10 * (10 ** uint256(decimals));
        // 10000000 * (10^decimals)

        // "Отправляем" все токены на баланс того, кто инициализировал создание контракта токена
        balanceOf[msg.sender] = totalSupply;

        // Указываем название токена
        name = "DAO Token Price";
        // Указываем символ токена
        symbol = "DAP";
    }

    // Внутренняя функция для перевода токенов
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != 0x0);
        // Проверка на пустой адрес
        require(balanceOf[_from] >= _value);
        // Проверка того, что отправителю хватает токенов для перевода
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        //

        balanceOf[_to] += _value;
        // Токены списываются у отправителя
        balanceOf[_from] -= _value;
        // Токены прибавляются получателю

        Transfer(_from, _to, _value);
        // Перевод токенов
    }

    // Функция для перевода токенов
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
        // Вызов внутренней функции перевода
    }

    // Функция для перевода "одобренных" токенов
    function transferFrom(address _from, address _to, uint256 _value) public {
        // Проверка, что токены были выделены аккаунтом _from для аккаунта _to
        require(_value <= allowance[_from][_to]);
        allowance[_from][_to] -= _value;
        // Отправка токенов
        _transfer(_from, _to, _value);
    }

    // Функция для "одобрения" перевода токенов
    function approve(address _to, uint256 _value) public {
        allowance[msg.sender][_to] = _value;
        Approval(msg.sender, _to, _value);
        // Вызов эвента для логгирования события одобрения перевода токенов
    }


    // Функциональность для DAO

    // Фукнция для предложения нового имени
    function newPrice(uint _newPrice) public {
        // Проверяем, что голосование не идет сейчас
        require(!voteActive);
        proposalPrice = _newPrice;
        voteActive = true;
    }

    // Фукнция для голосования
    function vote(bool _vote) public {
        // Проверяем, что идет голосование
        require(voteActive);

		require(!voted[msg.sender]);
		
		voted[msg.sender] = true;
		
        // Логика для голования
        if (_vote){
            election.current += int256(balanceOf[msg.sender]);
        }
        else {
            election.current -= int256(balanceOf[msg.sender]);

        }
        election.numberOfVotes += balanceOf[msg.sender];
    }

    function changePrice() public {
        // Проверяем, что голование активно
        require(voteActive);
        // Проверяем, что получили достаточное количество голосов
        require(election.numberOfVotes >= minVotes);
        // Если собрали нужное число голосов, то обновляем имя
        if (election.current >= int256(minVotes) ){
            price = proposalPrice;
        }

        // Сбрасываем все переменные для голосования
        election.numberOfVotes = 0;
        election.current = 0;
        voteActive = false;
    }

    // --- Функциональность для DAO
}