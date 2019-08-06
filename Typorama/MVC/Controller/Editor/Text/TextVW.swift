//
//  Text_VW.swift
//  Typorama
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum TextMenu : Int {
    
    case Styles
    case History
    case Color
    case Shadow
    case Gradient
    case Eraser
}

@objc protocol TextVWDelegate: class {
    
    @objc optional func text(view: TextVW, changeStyle style: infoStyle)
    @objc optional func text(view: TextVW, changeColor color: UIColor)
    
    @objc optional func text(view: TextVW, ChangeShadow value: Any, With type: ShadowValue)
}

class TextVW: UIView {

    weak var delegate : TextVWDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var vw_Menu: UIView!
    
    @IBOutlet var vw_History: HistoryVW!
    @IBOutlet var vw_Style: StypleVW!
    @IBOutlet var vw_Color: ColorVW!
    @IBOutlet var vw_Shadow: ShadowVW!
    @IBOutlet var vw_Gradient: GradientVW!
    @IBOutlet var vw_Eraser: EraserVW!
    
    @IBOutlet weak var clc_Menu: UICollectionView!
    
    var currentLayer = ZDStickerView()
    
    var muary_Menu = NSMutableArray()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        configureXIB()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        configureXIB()
    }
    func configureNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    func configureXIB() {
        
        self.contentView = configureNib()
        self.contentView.frame = bounds
        self.contentView.backgroundColor = .clear
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.contentView)
        
        self.contentView.backgroundColor = COLOR_GrayL240
        self.vw_Menu.backgroundColor = COLOR_White
        
        let nib_CellCrop = UINib(nibName: "cell_c_Menu", bundle: nil)
        self.clc_Menu.register(nib_CellCrop, forCellWithReuseIdentifier: "cell_c_Menu")
        
        let layout_Cat = self.clc_Menu.collectionViewLayout as! UICollectionViewFlowLayout
        layout_Cat.itemSize = CGSize(width: 70, height: 50)
        self.clc_Menu.collectionViewLayout = layout_Cat        
        
        self.setMenuArray()
        let dict : [String:String] = self.muary_Menu.object(at: 0) as! [String : String]
        self.action_SelectMenu(menu: TextMenu(rawValue: Int(dict["option"]!)!)!)
        
        self.vw_Style.delegate = self
        self.vw_History.delegate = self
        self.vw_Color.delegate = self
        self.vw_Shadow.delegate = self
    }
    
    func setMenuArray() {
     
        self.muary_Menu = NSMutableArray()
        if self.vw_History.muary_History.count > 0 {
        
            self.muary_Menu.add(["name":"History", "icon":"icon_history", "option": "1"])
        }
        
        self.muary_Menu.add(["name":"Styles", "icon":"icon_style", "option": "0"])
        self.muary_Menu.add(["name":"Color", "icon":"icon_color", "option": "2"])
        self.muary_Menu.add(["name":"Shadow", "icon":"icon_shadow", "option": "3"])
        self.muary_Menu.add(["name":"Gradient", "icon":"icon_gradient", "option": "4"])
        self.muary_Menu.add(["name":"Eraser", "icon":"icon_eraser", "option": "5"])
        
        self.clc_Menu.reloadData()
    }
    
    func action_SelectMenu(menu: TextMenu) {
        
        self.vw_History.isHidden = true
        self.vw_Style.isHidden = true
        self.vw_Color.isHidden = true
        self.vw_Shadow.isHidden = true
        self.vw_Gradient.isHidden = true
        self.vw_Eraser.isHidden = true
        
        if menu == TextMenu.History {
            
            self.vw_History.isHidden = false
        }
        else if menu == TextMenu.Styles {
            
            self.vw_Style.isHidden = false
        }
        else if menu == TextMenu.Color {
            
            self.vw_Color.isHidden = false
        }
        else if menu == TextMenu.Shadow {
            
            self.vw_Shadow.isHidden = false
        }
        else if menu == TextMenu.Gradient {
            
            self.vw_Gradient.isHidden = false
        }
        else {
            
            self.vw_Eraser.isHidden = false
        }
    }
    
    func addNewSticker() {
        
        let info_Style = self.vw_Style.muary_Layer[0]
        info_Style.index = 0
        self.delegate?.text?(view: self, changeStyle: info_Style)
    }
    
    func layerDidBeginEditing(sticker: ZDStickerView) {
        
        self.currentLayer = sticker
        self.vw_Color.color = (sticker.info as! infoLayer).color
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.vw_Color.color.getRed(&r, green: &g, blue: &b, alpha: &a)        
        self.vw_Color.sld_Opacity.value = Float(a)
    }
}

extension TextVW: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.muary_Menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cell_c_Menu = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_c_Menu", for: indexPath) as! cell_c_Menu
        
        let dict : [String:String] = self.muary_Menu.object(at: indexPath.row) as! [String : String]
        cell.lbl_Menu.text = dict["name"]
        cell.imgvw_Icon.image = UIImage(named: dict["icon"]!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict : [String:String] = self.muary_Menu.object(at: indexPath.row) as! [String : String]
        self.action_SelectMenu(menu: TextMenu(rawValue: Int(dict["option"]!)!)!)
    }
}

extension TextVW: StypleVWDelegate {
    
    func style(view: StypleVW, didSelected style: infoStyle) {

        self.vw_History.addToHistoty(style: style)
        self.delegate?.text?(view: self, changeStyle: style)
        
        if self.vw_History.muary_History.count == 1 {
            
            self.setMenuArray()
        }
    }
}

extension TextVW: HistoryVWDelegate {
    
    func history(view: HistoryVW, didSelected style: infoStyle) {
        
        self.delegate?.text?(view: self, changeStyle: style)
    }
}

extension TextVW: ColorVWDelegate {
    
    func color(view: ColorVW, didSelected color: UIColor) {
        
        self.delegate?.text?(view: self, changeColor: color)
    }
}

extension TextVW: ShadowVWDelegate {    
    
    func shadow(view: ShadowVW, Change value: Any, With type: ShadowValue) {
        
        self.delegate?.text?(view: self, ChangeShadow: value, With: type)
    }
}