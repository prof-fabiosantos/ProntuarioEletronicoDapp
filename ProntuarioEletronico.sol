// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProntuarioEletronico {
    struct RegistroMedico {
        string sintomasCriptografados;
        string diagnosticoCriptografado;
        string tratamentoCriptografado;
    }

    mapping(address => mapping(address => RegistroMedico)) public registros;
    mapping(address => bool) public medicos;
    mapping(address => mapping(address => bool)) public autorizacoes;

    function adicionarMedico(address medico) public {
        medicos[medico] = true;
    }

    function autorizarMedico(address medico) public {
        autorizacoes[msg.sender][medico] = true;
    }

    function revogarMedico(address medico) public {
        autorizacoes[msg.sender][medico] = false;
    }

    function adicionarRegistro(address paciente, string memory sintomas, string memory diagnostico, string memory tratamento) public {
        require(medicos[msg.sender], "Somente médicos podem adicionar registros.");
        require(autorizacoes[paciente][msg.sender], "Sem autorização do paciente.");

        RegistroMedico memory novoRegistro = RegistroMedico(sintomas, diagnostico, tratamento);
        registros[msg.sender][paciente] = novoRegistro;
    }

    function verRegistro(address medico, address paciente) public view returns(string memory, string memory, string memory) {
        require(msg.sender == paciente || autorizacoes[paciente][msg.sender], "Sem autorização para acessar o registro.");
        
        RegistroMedico memory registro = registros[medico][paciente];
        return (registro.sintomasCriptografados, registro.diagnosticoCriptografado, registro.tratamentoCriptografado);
    }
}
