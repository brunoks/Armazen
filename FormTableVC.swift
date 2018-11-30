//
//  FormTableVC.swift
//  Panfleto Online
//
//  Created by Luciano Pezzin on 14/09/2018.
//  Copyright © 2018 Panfleto Online. All rights reserved.
//

import UIKit
import SwiftMaskText
import PDFKit
import QuickLook

class FormList {
    var _Editable: Bool
    var Editable: Bool {
        get {
            return _Editable
        }
        set {
            _Editable = newValue
        }
    }
    init(Editable: Bool) {
        self._Editable = Editable
    }
}

struct isAutoFilledField {
    var isAutoFilled: Bool
    var textField: UITextField
}

struct ContractValue {
    var month: Double
    var value: Double
}
class FormTableVC: UITableViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate, QLPreviewControllerDataSource {
    
    
    @IBOutlet var cpf_name: UITextField!
    
    //cpf
    @IBOutlet var cpf_mother: UITextField!
    @IBOutlet var cpf_borth: UITextField!
    @IBOutlet var cpf_tf_number: UITextField!
    @IBOutlet var cpf_err_label: UILabel!
    @IBOutlet var cpf_gender_seg: UISegmentedControl!
    //cnpj
    @IBOutlet var cnpj_number: UITextField!
    @IBOutlet var cnpj_name: UITextField!
    @IBOutlet var cnpj_email: UITextField!
    @IBOutlet var cnpj_phone: UITextField!
    @IBOutlet var cnpj_err_label: UILabel!
    //contato
    @IBOutlet var textfield_email_contact: UITextField!
    @IBOutlet var textfield_phone_contact: UITextField!
    @IBOutlet var contact_err_label: UILabel!
    //cep
    @IBOutlet var cep_tf_number: UITextField!
    @IBOutlet var cep_tf_address: UITextField!
    @IBOutlet var cep_tf_street_number: UITextField!
    @IBOutlet var cep_tf_district: UITextField!
    @IBOutlet var cep_tf_city: UITextField!
    @IBOutlet var cep_tf_uf: UITextField!
    @IBOutlet var cep_tf_complement: UITextField!
    @IBOutlet var cep_err_label: UILabel!
    //checkouts
    @IBOutlet var checkout_tf_number: UITextField!
    @IBOutlet var checkout_swift_filais: UISwitch!
    
    @IBOutlet var contract_value_label: SwiftMaskField!
    @IBOutlet var contract_value_month: SwiftMaskField!
    @IBOutlet var checkout_err_label: UILabel!
    @IBOutlet var less_value_err: UILabel!
    //contract
    @IBOutlet var create_contract_err_label: UILabel!
    @IBOutlet var create_contract_button: UIButton!
    
    var isContract: Bool!
    var activityLoading: UIActivityIndicatorView!
    var link: String!
    var section1 = [FormList(Editable: false)]
    
    var section2 = [FormList(Editable: false)]
    
    var section3 = [FormList(Editable: false),
                    FormList(Editable: false),
                    FormList(Editable: false)]
    
    var section4 = [FormList(Editable: false)]
    
    var section5 = [FormList(Editable: false),
                    FormList(Editable: false)]
    
    var section6 = [FormList(Editable: false)]
    
    
    var list: [[FormList]] = [[],[],[],[],[],[]]
    var i = 1
    
    var isFilled = false
    var isCPFAutoFilled = false
    var isCEPAutoFilled = false
    var isCNPJAutoFilled = false
    var isContatoAutoFilled = false
    var filledFilds: [isAutoFilledField] = []
    var cpf: CPF!
    var cnpj: CNPJ!
    var cep: CEP!
    var contato: Contact!
    var child = SuccessView()
    var blurEffectView = UIVisualEffectView()
    var valueContract: ContractValue!
    
    @IBOutlet var back_btn: UIButton!
    let transition = CircularTransition()
    let _token = UserDefaults.standard.value(forKey: "token") as! String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list[0] = section1
        self.tableView.reloadData()
        
        self.mainStyles()
        self.delegate()
        self.CPFSearchButton()
        self.CNPJSearchButton()
        self.CEPSearchButton()
        self.CheckOutSearchButton()
        
        
    }
    func mainStyles() {
        self.cpf_gender_seg.layer.cornerRadius = self.cpf_gender_seg.frame.height / 2
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Regular", size: 15.0)
        label.textColor = UIColor.white
        if isContract {
            label.text = "Novo Contrato"
        } else {
            label.text = "Nova Proposta"
        }
        self.navigationItem.titleView = label
        tableView.tableFooterView = UIView()
    }

    func delegate() {
        self.cpf_name.delegate = self
        self.cpf_mother.delegate = self
        self.cpf_borth.delegate = self
        self.cpf_tf_number.delegate = self
        
        self.cnpj_number.delegate = self
        self.cnpj_name.delegate = self
        self.cnpj_email.delegate = self
        self.cnpj_phone.delegate = self
        self.textfield_email_contact.delegate = self
        self.textfield_phone_contact.delegate = self
        self.cep_tf_number.delegate = self
        self.cep_tf_address.delegate = self
        self.cep_tf_street_number.delegate = self
        self.cep_tf_district.delegate = self
        self.cep_tf_city.delegate = self
        self.cep_tf_uf.delegate = self
        self.cep_tf_complement.delegate = self
        self.checkout_tf_number.delegate = self
        self.contract_value_month.delegate = self
        self.contract_value_label.delegate = self
    }
    func createLoadingView() -> UIActivityIndicatorView {
        let act = UIActivityIndicatorView()
        act.style = .gray
        act.frame = CGRect(x: 5, y: 0, width: 35, height: 35)
        act.startAnimating()
        act.isHidden = false
        return act
        
    }
    private func swiftMaskAuto(_ tx: UITextField,_ string: String) {
        if tx == self.contract_value_month || tx == self.contract_value_label {
            let textField = tx as! SwiftMaskField
            let value = textField.text
            let value1 = value?.replacingOccurrences(of: ".", with: "")
            let value2 = value1?.replacingOccurrences(of: "R$ ", with: "")
            let value3 = value2?.replacingOccurrences(of: ",", with: "")
            switch value3!.count {
            case 3:
                textField.maskString = "R$ N.NNN"
            case 4:
                textField.maskString = "R$ NN.NNN"
            case 5:
                textField.maskString = "R$ NNN.NNN"
            case 6:
                textField.maskString = "R$ N.NNN.NNN"
            case 7:
                textField.maskString = "R$ NN.NNN.NNN"
            case 8:
                textField.maskString = "R$ NNN.NNN.NNN"
            case 9:
                textField.maskString = "R$ N.NNN.NNN.NNN"
            case 10:
                textField.maskString = "R$ NN.NNN.NNN.NNN"
            case 11:
                textField.maskString = "R$ NNN.NNN.NNN.NNN"
            default:
                break
            }
            if string == "" {
                switch value3!.count {
                case 4:
                    textField.maskString = "R$ NNN"
                case 5:
                    textField.maskString = "R$ N.NNN"
                case 6:
                    textField.maskString = "R$ NN.NNN"
                case 7:
                    textField.maskString = "R$ NNN.NNN"
                case 8:
                    textField.maskString = "R$ N.NNN.NNN"
                case 9:
                    textField.maskString = "R$ NN.NNN.NNN"
                case 10:
                    textField.maskString = "R$ NNN.NNN.NNN"
                case 11:
                    textField.maskString = "R$ N.NNN.NNN.NNN"
                case 12:
                    textField.maskString = "R$ NN.NNN.NNN.NNN"
                default:
                    break
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.swiftMaskAuto(textField, string)
        switch textField {
        case self.cpf_tf_number, self.cnpj_number, self.cep_tf_number, self.checkout_tf_number, self.contract_value_label, self.contract_value_month:
            let allowedCharacters = "0123456789"
            return allowedCharacters.contains(string) || range.length == 1
        default:
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.cpf_tf_number:
            self.searchCPF(UIButton())
        case self.cnpj_number:
            self.searchCNPJ(UIButton())
        case self.checkout_tf_number:
            self.confirmar_checkout_button(UIButton())
        case self.cep_tf_number:
            self.searchCEP(UIButton())
        default:
            textField.endEditing(true)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            for i in 0..<self.filledFilds.count {
                if self.filledFilds[i].textField == textField {
                    if self.filledFilds[i].isAutoFilled {
                        return false
                    } else {
                        return true
                    }
                } else if i == self.filledFilds.count - 1 {
                    let tf = isAutoFilledField(isAutoFilled: true, textField: textField)
                    self.filledFilds.append(tf)
                    return false
                }
            }
        } else {
            for i in 0..<self.filledFilds.count {
                if self.filledFilds[i].textField != textField {
                    let tf = isAutoFilledField(isAutoFilled: false, textField: textField)
                    self.filledFilds.append(tf)
                }
            }
        }
        return true
    }
    func CheckAutoFilledField(_ itsIs: Bool) {
        if self.checkCPF() {
            self.isCPFAutoFilled = itsIs
        }
        if self.checkCNPJ() {
            self.isCNPJAutoFilled = itsIs
        }
        if self.checkContato() {
            self.isContatoAutoFilled = itsIs
        }
        if self.checkCEP() {
            self.isCEPAutoFilled = itsIs
        }
        if !itsIs {
            let tf_cpf = isAutoFilledField(isAutoFilled: false, textField: self.cpf_tf_number)
            let tf_month = isAutoFilledField(isAutoFilled: false, textField: self.contract_value_label)
            let tf_value = isAutoFilledField(isAutoFilled: false, textField: self.contract_value_month)
            self.filledFilds = [tf_cpf,tf_month,tf_value]
        }
    }

    func clearAllTextFields() {
        self.cpf_name.text = .none
        self.cpf_mother.text = .none
        self.cpf_borth.text = .none
        
        self.cnpj_number.text = .none
        self.cnpj_name.text = .none
        self.cnpj_email.text = .none
        self.cnpj_phone.text = .none
        self.textfield_email_contact.text = .none
        self.textfield_phone_contact.text = .none
        self.cep_tf_number.text = .none
        self.cep_tf_address.text = .none
        self.cep_tf_street_number.text = .none
        self.cep_tf_district.text = .none
        self.cep_tf_city.text = .none
        self.cep_tf_uf.text = .none
        self.cep_tf_complement.text = .none
        self.checkout_tf_number.text = .none
        self.contract_value_month.text = "-"
        self.contract_value_label.text = "-"
        
        self.section1.first?.Editable = false
        self.section2.first?.Editable = false
        self.section3.first?.Editable = false
        self.section4.first?.Editable = false
        self.section5.first?.Editable = false
    }
    func CPFSearchButton () {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "search.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.cpf_tf_number.frame.size.width - 50), y: CGFloat(5), width: CGFloat(45), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.searchCPF), for: .touchUpInside)
        self.cpf_tf_number.rightViewMode = .always
        self.cpf_tf_number.rightView = button
    }
    func CEPSearchButton () {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "search.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.cep_tf_number.frame.size.width - 50), y: CGFloat(5), width: CGFloat(45), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.searchCEP), for: .touchUpInside)
        self.cep_tf_number.rightViewMode = .always
        self.cep_tf_number.rightView = button
    }
    func CheckOutSearchButton () {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "search.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.cep_tf_number.frame.size.width - 50), y: CGFloat(5), width: CGFloat(45), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.confirmar_checkout_button(_:)), for: .touchUpInside)
        self.checkout_tf_number.rightViewMode = .always
        self.checkout_tf_number.rightView = button
    }
    func CNPJSearchButton () {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "search.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.cnpj_number.frame.size.width - 50), y: CGFloat(5), width: CGFloat(45), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.searchCNPJ), for: .touchUpInside)
        self.cnpj_number.rightViewMode = .always
        self.cnpj_number.rightView = button
    }
    
    func searchLoading(_ actualS: Int,_ section: Int,_ text: String) -> UIView{
        if actualS == section {
            let view = UIView()
            view.backgroundColor = .clear
            
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35)
            
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: "Helvetica Light", size: 12)
            label.tintColor = UIColor(red: 165/255, green: 22/255, blue: 33/255, alpha: 1.0)
            label.textColor = UIColor.gray
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            view.addSubview(label)
            
            return view
        } else {
            return UIView()
        }
    }
    
    func login() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func textFeildEmpty(textField: UITextField) {
        if textField.text == "" {
            textField.backgroundColor = (UIColor.init(red: 217/255, green: 59/255, blue: 65/255, alpha: 0.6))
            textField.transform = CGAffineTransform(translationX: 2, y: 0)
            UIView.animate(withDuration: 0.05, delay: 0, options:  [.curveEaseIn, .repeat], animations: {
                UIView.setAnimationRepeatCount(5.0)
                textField.transform = CGAffineTransform(translationX: -2, y: 0)
            }) { (suc) in
                textField.transform = CGAffineTransform(translationX: 0, y: 0)
                textField.backgroundColor = .none
            }
        }
    }
    
    func textFeildErr(textField: UITextField) {
        textField.backgroundColor = (UIColor.init(red: 217/255, green: 59/255, blue: 65/255, alpha: 0.6))
        textField.transform = CGAffineTransform(translationX: 2, y: 0)
        UIView.animate(withDuration: 0.05, delay: 0, options:  [.curveEaseIn, .repeat], animations: {
            UIView.setAnimationRepeatCount(5.0)
            textField.transform = CGAffineTransform(translationX: -2, y: 0)
        }) { (suc) in
            textField.transform = CGAffineTransform(translationX: 0, y: 0)
            textField.backgroundColor = .none
        }
    }
    
    @IBAction func searchCPF(_ sender: UIButton) {
        let cepFormat = self.cpf_tf_number.text!
        if self.cpf_tf_number.text != ""  && (cepFormat.isValidCPF) {
            let cpfoutFormat = self.cpf_tf_number.text!
            let value1 = cpfoutFormat.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            let cpf = Verify(param: value2, token: self._token)
            
            let act = self.createLoadingView()
            self.cpf_tf_number.leftViewMode = .always
            self.cpf_tf_number.leftView = act
            
            cpf.verifyCPF { (succ) in
                self.cpf_tf_number.leftView = nil
                
                
                self.list[0] = []
                self.deleteRows(numberOfRows: self.section1.count, section: 0)
                
                let form = FormList(Editable: false)
                if self.section1.count < 3 {
                    self.section1.append(form)
                    self.section1.append(form)
                }
                self.newRows(section: 0, self.section1)
                
                if succ.ProcessResult.success {
                    self.CheckAutoFilledField(false)
                    switch succ.ProcessResult.type {
                    case "not_found":
                        self.cpf = succ
                        self.errLabel("CPF Não Encontrado", self.cpf_err_label)
                    case "invalid_format":
                        self.errLabel("CPF Inválido", self.cpf_err_label)
                    case "new_client":
                        if self.isFilled {
                            self.clearAllTextFields()
                        } else {
                            self.isFilled = true
                        }
                        self.cpf_name.text = succ.name
                        self.cpf_borth.text  = succ.born
                        self.cpf_mother.text  = succ.mother
                        self.cpf = succ
                        self.cpf_gender_seg.selectedSegmentIndex = succ.gender == "F" ? 1 : 0
                    case "client_exist":
                        if self.isFilled {
                            self.clearAllTextFields()
                        } else {
                            self.isFilled = true
                        }
                        self.cpf_name.text = succ.contract.cpf.name
                        self.cpf_borth.text  = succ.contract.cpf.born
                        self.cpf_mother.text  = succ.contract.cpf.mother
                        self.cpf_gender_seg.selectedSegmentIndex = succ.contract.cpf.gender == "F" ? 1 : 0
                        self.cpf = succ.contract.cpf
                        
                        self.cnpj_number.text = "\(succ.contract.cnpj.cnpj)"
                        self.cnpj_phone.text = succ.contract.cnpj.phone
                        self.cnpj_email.text = succ.contract.cnpj.email
                        self.cnpj_name.text = succ.contract.cnpj.company_name
                        
                        let form1 = FormList(Editable: false)

                        if self.section2.count < 3 {
                            self.section2.append(form1)
                            self.section2.append(form1)
                        }
                        
                        self.cnpj = succ.contract.cnpj
                        
                        self.cep_tf_address.text = succ.contract.cep.address
                        self.cep_tf_uf.text = succ.contract.cep.uf
                        self.cep_tf_city.text = succ.contract.cep.city
                        self.cep_tf_number.text = "\(succ.contract.cep.cep)"
                        self.cep_tf_district.text = succ.contract.cep.district
                        self.cep_tf_street_number.text = succ.contract.cep.number
                        
                        let form = FormList(Editable: false)
                        if self.section4.count < 3 {
                            self.section4.append(form)
                            self.section4.append(form)
                        }
                        self.cep = succ.contract.cep
                        
                        self.textfield_email_contact.text = succ.contract.email
                        self.textfield_phone_contact.text = succ.contract.phone
                        
                        let contact = Contact(phone: succ.contract.phone, email: succ.contract.email)
                        self.contato = contact
                        
                        self.CheckAutoFilledField(true)
                    default:
                        break
                    }
                } else {
                    self.errLabel(succ.ProcessResult.mensagem!, self.cpf_err_label)
                    if succ.ProcessResult.type == "invalid_auth" {
                        self.login()
                    }
                }
            }
        } else {
            if self.cpf_tf_number.text == "" {
                self.errLabel("Campo Vazio", self.cpf_err_label)
                self.textFeildEmpty(textField: self.cpf_tf_number)
            }
            if !(self.cpf_tf_number.text?.isValidCPF)! {
                self.errLabel("CPF Inválido", self.cpf_err_label)
            }
        }
    }
    @IBAction func searchCNPJ(_ sender: UIButton) {
        if self.cnpj_number.text != "" && (self.cnpj_number.text?.isValidCNPJ)! {
            let cpfoutFormat = self.cnpj_number.text!
            let value1 = cpfoutFormat.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            let value3 = value2.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
            
            let act = self.createLoadingView()
            self.cnpj_number.leftViewMode = .always
            self.cnpj_number.leftView = act
            
            let cnpj = Verify(param: value3, token: self._token)
            cnpj.verifyCNPJ { (succ) in
                
                self.cnpj_number.leftView = nil
                let form = FormList(Editable: false)
                if self.section2.count < 3 {
                    self.section2.append(form)
                    self.section2.append(form)
                }
                self.newRows(section: 1, self.section2)
                
                if succ.ProcessResult.success {
                    switch succ.ProcessResult.type {
                        
                    case "not_found":
                        self.errLabel("CNPJ Não Encontrado", self.cnpj_err_label)
                        
                        let cnpjnotfound = CNPJ(value3, self.cnpj_name.text!, self.cnpj_phone.text!, self.cnpj_email.text!)
                        self.cnpj = cnpjnotfound
                    case "invalid_format":
                        self.errLabel("CNPJ Inválido", self.cnpj_err_label)
                    case "new_business":
                        self.cnpj_phone.text = succ.phone
                        self.cnpj_email.text = succ.email
                        self.cnpj_name.text = succ.company_name
                        self.cnpj = succ
                    default:
                        break
                    }
                } else {
                    if succ.ProcessResult.type == "invalid_auth" {
                        self.login()
                    }
                }
            }
        } else {
            if self.cnpj_number.text == "" {
                self.textFeildEmpty(textField: self.cnpj_number)
                self.errLabel("Campo Vazio", self.cnpj_err_label)
            }
            if !(self.cnpj_number.text?.isValidCNPJ)! && self.cnpj_number.text != "" {
                self.textFeildEmpty(textField: self.cnpj_number)
                self.errLabel("CNPJ Inválido", self.cnpj_err_label)
            }
        }
    }
    
    
    @IBAction func searchCEP(_ sender: UIButton) {
        if self.cep_tf_number.text != "" {
            let cepFormat = self.cep_tf_number.text!
            let value1 = cepFormat.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            
            let act = self.createLoadingView()
            self.cep_tf_number.leftViewMode = .always
            self.cep_tf_number.leftView = act
            
            let cep = Verify(param: value2, token: self._token)
            cep.verifyCEP { (succ) in
                self.cep_tf_number.leftView = nil
                
                let form = FormList(Editable: false)
                if self.section4.count < 3 {
                    self.section4.append(form)
                    self.section4.append(form)
                }
                self.newRows(section: 3, self.section4)
                
                if succ.ProcessResult.success {
                    switch succ.ProcessResult.type {
                    case "not_found":
                        self.errLabel("CEP Não Encontrado", self.cep_err_label)
                    case "new_cep":
                        self.cep_tf_address.text = succ.address
                        self.cep_tf_uf.text = succ.uf
                        self.cep_tf_city.text = succ.city
                        self.cep_tf_district.text = succ.district
                        self.cep_tf_street_number.text = succ.number
                        self.cep = succ
                    default:
                        break
                    }
                } else {
                    if succ.ProcessResult.type == "invalid_auth" {
                        self.login()
                    }
                }
            }
        }
    }
    @objc func changeRows() {
        switch i {
        case 0:
            print("begin")
        case 1:
            self.list[0] = []
            if section2.count > 3 {
                for _ in 0..<self.section2.count - 3{
                    self.section2.removeLast()
                }
            }
            self.deleteRows(numberOfRows: self.section1.count, section: 0)
            self.newRows(section: 1, self.section2)
            self.tableView.footerView(forSection: 0)
            i = 2
            
        case 2:
            list[1] = []
            if section3.count > 3 {
                for _ in 0..<self.section3.count - 3{
                    self.section3.removeLast()
                }
            }
            self.deleteRows(numberOfRows: self.section2.count, section: 1)
            self.newRows(section: 2, self.section3)
            i = 3
            
        case 3:
            list[2] = []
            if section4.count > 3 {
                for _ in 0..<self.section4.count - 3{
                    self.section4.removeLast()
                }
            }
            self.deleteRows(numberOfRows: self.section3.count, section: 2)
            self.newRows(section: 3, self.section4)
            i = 4
            
        case 4:
            list[3] = []
            if section5.count > 3 {
                for _ in 0..<self.section5.count - 3{
                    self.section5.removeLast()
                }
            }
            self.deleteRows(numberOfRows: self.section4.count, section: 3)
            self.newRows(section: 4, self.section5)
            i = 5
        case 5:
            list[4] = []
            if section6.count > 1 {
                for _ in 0..<self.section6.count - 3{
                    self.section6.removeLast()
                }
            }
            self.deleteRows(numberOfRows: self.section5.count, section: 4)
            self.newRows(section: 5, self.section6)
            i = 6
        default:
            break
        }
    }
    
    
    func newRows(section: Int,_ rows: [FormList]) {
        
        var indexPath: [IndexPath] = []
        for i in 0..<rows.count {
            let index = IndexPath(row: i, section: section)
            indexPath.append(index)
        }
        self.list[section] = rows
        self.tableView.reloadData()
        self.tableView.reloadRows(at: indexPath, with: .bottom)
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    func deleteRows(numberOfRows: Int, section: Int) {
        var indexPath: [IndexPath] = []
        
        for i in 0..<numberOfRows {
            let index = IndexPath(row: i, section: section)
            indexPath.append(index)
        }
        tableView.deleteRows(at: indexPath, with: .top)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5 {
            return 15
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = Label()
        label.textColor = UIColor.darkGray
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50)
        let editButton = UIButton()
        let pencilView = UIImageView(image: #imageLiteral(resourceName: "pencil"))
        pencilView.frame = CGRect(x: 5, y: 12.5, width: 20, height: 20)
        
        editButton.setImage(pencilView.image, for: .normal)
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "checked"))
        
        switch section {
        case 0:
            label.text = "Digite o CPF"
        case 1:
            label.text = "Digite o CNPJ"
        case 2:
            label.text = "Digite o Contato"
        case 3:
            label.text = "Digite o CEP"
        case 4:
            label.text = "Digite o Checkout"
        case 5:
            return UIView()
        default:
            break
        }
        
        editButton.tag = section
        editButton.addTarget(self, action: #selector(editSection(_:)), for: .touchDown)
        
        let view = UIView()
        editButton.frame = CGRect(x: 12.5, y: 12.5, width: 25, height: 25)
        
        view.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        //view.frame = CGRect(x: 25, y: 0, width: self.view.frame.size.width - 50, height: 50)
        view.layer.cornerRadius = 25
        if list[section].count > 0 {
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        imageView.contentMode = .scaleAspectFit
        view.addSubview(editButton)
        
        
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 25
        
        containerView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        let width = containerView.frame.size.width - 50
        let height = containerView.frame.size.height
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        print(width)
        view.preservesSuperviewLayoutMargins = false
        
        containerView.addSubview(label)
        if Checked(section: section) {
            containerView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: containerView.frame.height - 15).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: containerView.frame.height - 15).isActive = true
            imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30).isActive = true
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        }
        
        //containerView.addSubview(editButton)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return containerView
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list[section].count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            changeRows()
        default:
            break
        }
    }
    func createChild(_ result: ProcessResult,_ message: String) {
        if let child = Bundle.main.loadNibNamed("SuccessPopUp", owner: self, options: nil)?.first as? SuccessView {
            child.frame = CGRect(x: 20, y: (self.tableView.frame.height / 4) - ((self.view.frame.height * 0.5) / 4), width: self.view.frame.width - 40, height: self.view.frame.height * 0.5)
            
            let blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            tableView.isScrollEnabled = false
            child.layer.cornerRadius = 16
            child.layer.masksToBounds = true
            
            if result.success {
                child.share_button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
                child.finalize_button.addTarget(self, action: #selector(dismissChild), for: .touchDown)
            } else {
                child.finalize_button.addTarget(self, action: #selector(closePop), for: .touchDown)
                child.share_button.isHidden = true
            }
            child.share_button.addTarget(self, action: #selector(sharedAction), for: .touchDown)
            if !result.success {
                child.message.text = message
                child.suc_err.image = UIImage(named: "error")
            } else {
                child.suc_err.image = UIImage(named: "success")
            }
            child.layer.shadowColor = UIColor.darkGray.cgColor
            child.layer.shadowRadius = 1
            child.layer.shadowOpacity = 0.6
            child.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
            
            
            self.tableView.addSubview(blurEffectView)
            self.tableView.addSubview(child)
            self.tableView.bringSubviewToFront(child)
            
            blurEffectView.effect = nil
            child.alpha = 0
            child.transform = CGAffineTransform(translationX: 0, y: -15)
            UIView.animate(withDuration: 0.3, animations: {
                child.alpha = 1
                child.transform = CGAffineTransform(translationX: 0, y: 0)
                self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
            }) { (_) in
            }
            self.child = child
        }
    }
    @objc func closePop() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.child.alpha = 0
            self.blurEffectView.alpha = 0
        }) { (_) in
            self.child.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    @objc func dismissChild() {
        UIView.animate(withDuration: 0.3, animations: {
            self.child.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (_) in
            self.child.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc func sharedAction() {
        if self.link != nil {
            self.DownloadPDF(self.link)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = back_btn.center
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = back_btn.center
        return transition
    }
    
    @IBAction func dismiss_btn(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "home") as! ViewController
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func checkAllFields() -> Bool {
        if self.cpf != nil &&
            self.checkCPF() &&
            self.cnpj != nil &&
            self.checkCNPJ() &&
            self.cep != nil &&
            self.checkCEP() &&
            self.contato != nil &&
            self.checkContato() &&
            (self.cpf_tf_number.text?.isValidCPF)! &&
            (self.cnpj_number.text?.isValidCNPJ)! &&
            self.checkout_tf_number.text != "" &&
            self.contract_value_label.text != "" &&
            self.contract_value_month.text != "" {
            return true
        } else {
            return false
        }
    }
    
    private func getPaymentMonth(_ value: String) -> Double {
        let value1 = value.replacingOccurrences(of: "R$ ", with: "")
        let value2 = value1.replacingOccurrences(of: ".", with: "")
        let value3 = value2.replacingOccurrences(of: ",", with: ".")
        
        let valueContract = Double(value3)
        
        if valueContract != nil {
            return valueContract!
        }
        return Double()
    }
    
    private func getValueContract(_ value: String) -> Double {
        let value1 = value.replacingOccurrences(of: "R$ ", with: "")
        let value2 = value1.replacingOccurrences(of: ".", with: "")
        let value3 = value2.replacingOccurrences(of: ",", with: ".")
        
        let valueContract = Double(value3)
        
        if valueContract != nil {
            return valueContract!
        }
        return Double()
    }

    @IBAction func gerar_contrato(_ sender: UIButton) {
        let act = self.createLoadingView()
        act.style = .white
        act.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        self.create_contract_button.addSubview(act)
        if checkAllFields() {
            let checkout = Int(self.checkout_tf_number.text!)
            let contract = Contract(cpf: self.cpf, CNPJ: self.cnpj, CEP: self.cep, contato: self.contato, isContract: self.isContract, checkOuts: checkout!, filials: self.checkout_swift_filais.isOn,  accesstion: getValueContract(self.contract_value_label.text!), month_payment: getPaymentMonth(self.contract_value_month.text!))
            let newContract = OrdersData(token: self._token, contract: contract)
            newContract.newOrder { (suc) in
                act.isHidden = true
                if suc.ProccessResult.success {
                    let link = suc.link
                    self.link = link
                    self.createChild(suc.ProccessResult, "")
                } else {
                    self.errLabel(suc.ProccessResult.mensagem!, self.create_contract_err_label)
                    self.createChild(suc.ProccessResult, suc.ProccessResult.mensagem!)
                    if suc.ProccessResult.type == "invalid_auth" {
                        self.login()
                    }
                }
            }
        } else {
            act.isHidden = true
            self.errLabel("Preencha todos os campos", self.create_contract_err_label)
        }
    }
    
    var itemURL = URL(string: "")
    var fileURL = URL(string: "")
    @objc func DownloadPDF(_ path:String) {
        let view = LoadViewAct()
        self.child.addSubview(view)
        view.topAnchor.constraint(equalTo: self.child.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.child.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.child.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.child.trailingAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.itemURL = URL(string: path)
            let quickLookController = QLPreviewController()
            quickLookController.dataSource = self
            
            let data = NSData(contentsOf: self.itemURL!)
            do {
                let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                self.fileURL = documentsDirectoryURL.appendingPathComponent((self.itemURL?.lastPathComponent)!)
                
                try data?.write(to: self.fileURL!, options: .atomic)
                if QLPreviewController.canPreview((self.itemURL as QLPreviewItem?)!) {
                    quickLookController.currentPreviewItemIndex = 0
                    self.present(quickLookController, animated: true, completion: nil)
                    view.removeFromSuperview()
                }
            } catch {
                // cant find the url resource
            }
        }
    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.fileURL! as QLPreviewItem
    }
    @objc func confirmar_checkout_button(_ sender: Any) {
        if self.checkout_tf_number.text != "" {
            let string = self.checkout_tf_number.text!
            let value1 = string.replacingOccurrences(of: ".", with: "")
            let value2 = value1.replacingOccurrences(of: ",", with: "")
            let value3 = value2.replacingOccurrences(of: "R$ ", with: "")
            print(value3)
            let checks = Int(value3)
            
            let act = self.createLoadingView()
            self.checkout_tf_number.leftViewMode = .always
            self.checkout_tf_number.leftView = act
            
            let cep = Verify(filials: self.checkout_swift_filais.isOn, checkOuts: checks!, token: self._token)
            cep.VerifyCheckOut { (succ) in
                if succ.result.success {
                    self.checkout_tf_number.leftView = nil
                    self.contract_value_month.text = "R$ " + succ.month_payment
                    self.contract_value_label.text = "R$ " + succ.accession
                    
                    self.valueContract = ContractValue(month: self.getPaymentMonth(succ.month_payment), value: self.getValueContract(succ.accession))
                    
                    let form = FormList(Editable: false)
                    if self.section5.count == 2 {
                        self.section5.append(form)
                    }
                    self.newRows(section: 4, self.section5)
                    
                } else {
                    self.errLabel("Houve algum erro. Verifique sua internet e tente novamente.", self.checkout_err_label)
                }
            }
        } else {
            self.textFeildEmpty(textField: self.checkout_tf_number)
            self.errLabel("Campo Vazio!", self.checkout_err_label)
        }
    }
    
    @IBAction func confirmar_checkout(_ sender: UIButton) {
        print(self.getValueContract(self.contract_value_label.text!), self.valueContract.value, self.getPaymentMonth(self.contract_value_month.text!),((self.valueContract?.month)!))
        if self.getValueContract(self.contract_value_label.text!) >= self.valueContract.value && self.getPaymentMonth(self.contract_value_month.text!) >= (self.valueContract?.month)!{
            self.section5.first?.Editable = true
            self.changeRows()
        } else {
            if self.getValueContract(self.contract_value_label.text!) < self.valueContract.value && self.getPaymentMonth(self.contract_value_month.text!) < (self.valueContract?.month)! {
                self.errLabel("Valores inferiores ao recomendado", self.less_value_err)
                self.textFeildErr(textField: self.contract_value_label)
                self.textFeildErr(textField: self.contract_value_month)
            } else {
                if self.getValueContract(self.contract_value_label.text!) < self.valueContract.value {
                    self.errLabel("Valor inferior ao recomendado: \(self.valueContract.value)", self.less_value_err)
                    self.textFeildErr(textField: self.contract_value_label)
                } else             if self.getPaymentMonth(self.contract_value_month.text!) < (self.valueContract?.month)! {
                    self.errLabel("Valor inferior ao recomendado \(self.valueContract.month)", self.less_value_err)
                    self.textFeildErr(textField: self.contract_value_month)
                }
            }
        }
    }
    
    func checkContato() -> Bool {
        if self.textfield_email_contact.text != "" && self.textfield_phone_contact.text != "" {
            self.section3.first?.Editable = true
            return true
        } else {
            return false
        }
    }
    @IBAction func confirmar_numero(_ sender: UIButton) {
        if self.checkContato() {
            let tel = String(self.textfield_phone_contact.text!)
            let telefone = tel
            let value1 = telefone.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            let value3 = value2.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            let value4 = value3.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            
            
            print(value3)
            let contato = Contact(phone: value4, email: self.textfield_email_contact.text!)
            self.contato = contato
            self.changeRows()
        } else {
            self.errLabel("Preencha todos os Campos!", self.contact_err_label)
            self.textFeildEmpty(textField: self.textfield_email_contact)
            self.textFeildEmpty(textField: self.textfield_phone_contact)
        }
    }
    
    func checkCEP() -> Bool {
        if self.cep_tf_number.text != "" &&
            self.cep_tf_city.text != "" &&
            self.cep_tf_uf.text != "" &&
            self.cep_tf_address.text != "" &&
            self.cep_tf_district.text != "" &&
            self.cep_tf_complement.text != "" &&
            self.cep_tf_street_number.text != "" {
            self.section4.first?.Editable = true
            return true
        } else {
            return false
        }
    }
    @IBAction func confirmar_CEP(_ sender: UIButton) {
        if checkCEP() {
            
            let cepFormat = self.cep_tf_number.text!
            let value1 = cepFormat.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            let value = Int(value2)
            let result = ProcessResult(success: true, type: "", mensagem: "")
            let cep = CEP(cep: value!, address: self.cep_tf_address.text!, number:  self.cep_tf_street_number.text!, complement: self.cep_tf_complement.text!, district: self.cep_tf_district.text!, city: self.cep_tf_city.text!, uf: self.cep_tf_uf.text!, result: result)
            
            self.cep = cep
            self.changeRows()
        } else {
            self.errLabel("Preencha todos os Campos!", self.cep_err_label)
            self.textFeildEmpty(textField: self.cep_tf_number)
            self.textFeildEmpty(textField: self.cep_tf_city)
            self.textFeildEmpty(textField: self.cep_tf_uf)
            self.textFeildEmpty(textField: self.cep_tf_address)
            self.textFeildEmpty(textField: self.cep_tf_district)
            self.textFeildEmpty(textField: self.cep_tf_complement)
            self.textFeildEmpty(textField: self.cep_tf_street_number)
        }
    }
    func checkCNPJ() -> Bool {
        if self.cnpj_number.text != "" &&
            self.cnpj_name.text != "" &&
            self.cnpj_phone.text != "" &&
            self.cnpj_email.text != "" &&
            (self.cnpj_number.text?.isValidCNPJ)!{
            self.section2.first?.Editable = true
            return true
        } else {
            return false
        }
    }
    @IBAction func confirmar_cnpj(_ sender: UIButton) {
        if checkCNPJ() {
            let cpfoutFormat = self.cnpj_number.text!
            let value1 = cpfoutFormat.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            let value3 = value2.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
            
            let tel = String(self.cnpj_phone.text!)
            let telefone = tel
            let tel1 = telefone.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            let tel2 = tel1.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
            let tel3 = tel2.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            print(tel3)
            let cnpj = CNPJ(value3, self.cnpj_name.text!, tel3, self.cnpj_email.text!)
            self.cnpj = cnpj
            self.changeRows()
        } else if !(self.cnpj_number.text?.isValidCNPJ)! {
            self.errLabel("CNPJ Inválido", self.cnpj_err_label)
            self.textFeildEmpty(textField: self.cnpj_number)
        } else {
            self.errLabel("Preencha todos os Campos!", self.cnpj_err_label)
            self.textFeildEmpty(textField: self.cnpj_number)
            self.textFeildEmpty(textField: self.cnpj_name)
            self.textFeildEmpty(textField: self.cnpj_phone)
            self.textFeildEmpty(textField: self.cnpj_email)
        }
    }
    
    func checkCPF() -> Bool {
        if self.cpf_tf_number.text != "" && self.cpf_name.text != "" && self.cpf_borth.text != "" && self.cpf_mother.text != "" && (self.cpf_tf_number.text?.isValidCPF)! {
            self.section1.first?.Editable = true
            return true
        } else {
            return false
        }
    }
    
    @IBAction func confirmar_cpf(_ sender: UIButton) {
        if self.checkCPF() {
            let result = ProcessResult(success: true, type: "", mensagem: "")
            let cpfoutFormat = self.cpf_tf_number.text!
            let value1 = cpfoutFormat.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            let value2 = value1.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            
            
            let cpf = CPF(id: self.cpf.id, cpf: value2, name: self.cpf_name.text!, gender: self.cpf_gender_seg.selectedSegmentIndex == 0 ? "M":"F", born: self.cpf_borth.text!, mother: self.cpf_mother.text!, process: result)
            self.cpf = cpf
            
            self.changeRows()
        } else if !(self.cpf_tf_number.text?.isValidCPF)! {
            self.errLabel("CPF Inválido", self.cpf_err_label)
        } else {
            self.errLabel("Preencha todos os Campos!", self.cpf_err_label)
            self.textFeildEmpty(textField: self.cpf_tf_number)
            self.textFeildEmpty(textField: self.cpf_name)
            self.textFeildEmpty(textField: self.cpf_borth)
            self.textFeildEmpty(textField: self.cpf_mother)
        }
    }
    
    
    
    func errLabel(_ text: String,_ label: UILabel) {
        label.alpha = 0
        label.text = text
        label.transform = CGAffineTransform(translationX: 0, y: -15)
        if label.isHidden {
            label.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                label.alpha = 1
                label.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseOut, animations: {
                    label.transform = CGAffineTransform(translationX: 0, y: -15)
                    label.alpha = 0
                }, completion: { (_) in
                    label.isHidden = true
                })
            }
        }
    }
    
    class Label: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont.boldSystemFont(ofSize: 14)
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
    }
    
    func setToList(i: Int) -> [FormList] {
        
        switch i {
        case 0:
            return section1
        case 1:
            return section2
        case 2:
            return section3
        case 3:
            return section4
        case 4:
            return section5
        case 5:
            return section6
        default:
            return section1
        }
    }
    
    @objc func editSection(_ sender: UIButton) {
        self.i = sender.tag + 1
        for i in 0..<list.count {
            let rows = self.tableView.numberOfRows(inSection: i)
            if rows > 0 && i != sender.tag {
                self.list[i] = []
                self.deleteRows(numberOfRows: rows, section: i)
            }
        }
        if self.list[sender.tag].count == 0 {
            self.list[sender.tag] = setToList(i: sender.tag)
            self.newRows(section: sender.tag, list[sender.tag])
        }
        
    }
    
    func Checked(section: Int) -> Bool {
        if ((section1.first?.Editable)! && section == 0) {
            return true
        }
        if ((section2.first?.Editable)! && section == 1) {
            return true
        }
        if ((section3.first?.Editable)! && section == 2) {
            return true
        }
        if ((section4.first?.Editable)! && section == 3) {
            return true
        }
        if ((section5.first?.Editable)! && section == 4) {
            return true
        }
        return false
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = super.tableView(self.tableView, cellForRowAt: indexPath) as? CellForSectionOne {
            cell.configure(rows: self.list[indexPath.section].count, row: indexPath.row, seciton: indexPath.section, width: self.tableView.frame.width - 50)
        return cell
        }
        return UITableViewCell()
    }
    
}
extension String {
    var isValidCNPJ: Bool {
        let numbers = characters.flatMap({Int(String($0))})
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[11] * 2 +
            numbers[10] * 3 +
            numbers[9] * 4 +
            numbers[8] * 5 +
            numbers[7] * 6 +
            numbers[6] * 7 +
            numbers[5] * 8 +
            numbers[4] * 9 +
            numbers[3] * 2 +
            numbers[2] * 3 +
            numbers[1] * 4 +
            numbers[0] * 5 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[12] * 2 +
            numbers[11] * 3 +
            numbers[10] * 4 +
            numbers[9] * 5 +
            numbers[8] * 6 +
            numbers[7] * 7 +
            numbers[6] * 8 +
            numbers[5] * 9 +
            numbers[4] * 2 +
            numbers[3] * 3 +
            numbers[2] * 4 +
            numbers[1] * 5 +
            numbers[0] * 6 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
    var isValidCPF: Bool {
        let numbers = characters.flatMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
}
