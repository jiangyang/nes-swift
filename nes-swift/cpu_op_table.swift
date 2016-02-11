enum OPCODE {
  case BRK,ORA,KIL,SLO,PHP,ASL,NOP,ANC,BPL,CLC,JSR,AND,RLA,BIT,ROL,PLP,BMI,SEC,RTI,EOR,
  SRE,LSR,PHA,ALR,JMP,BVC,CLI,RTS,ADC,RRA,ROR,PLA,ARR,BVS,SEI,STA,SAX,STY,STX,DEY,TXA,
  XAA,BCC,AHX,TYA,TXS,TAS,SHY,SHX,LDY,LDA,LDX,LAX,TAY,TAX,BCS,CLV,TSX,LAS,CPY,CMP,DCP,
  DEC,INY,DEX,AXS,BNE,CLD,CPX,SBC,ISC,INC,INX,BEQ,SED
}

let OPTable: [OP] = [
  OP(opcode: OPCODE.BRK, mode: 6, size: 1, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.ORA, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 7, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.ORA, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.ASL, mode: 11, size: 2, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 11, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.PHP, mode: 6, size: 1, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.ORA, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ASL, mode: 4, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ANC, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ORA, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ASL, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 1, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.BPL, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.ORA, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 9, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ORA, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ASL, mode: 12, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 12, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.CLC, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ORA, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 3, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.ORA, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.ASL, mode: 2, size: 3, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.SLO, mode: 2, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.JSR, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.AND, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 7, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.BIT, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.AND, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.ROL, mode: 11, size: 2, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 11, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.PLP, mode: 6, size: 1, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.AND, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ROL, mode: 4, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ANC, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.BIT, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.AND, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ROL, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 1, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.BMI, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.AND, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 9, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.AND, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ROL, mode: 12, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 12, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SEC, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.AND, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 3, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.AND, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.ROL, mode: 2, size: 3, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.RLA, mode: 2, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.RTI, mode: 6, size: 1, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.EOR, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 7, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.EOR, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.LSR, mode: 11, size: 2, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 11, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.PHA, mode: 6, size: 1, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.EOR, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LSR, mode: 4, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ALR, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.JMP, mode: 1, size: 3, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.EOR, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LSR, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 1, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.BVC, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.EOR, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 9, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.EOR, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LSR, mode: 12, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 12, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.CLI, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.EOR, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 3, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.EOR, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.LSR, mode: 2, size: 3, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.SRE, mode: 2, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.RTS, mode: 6, size: 1, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.ADC, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 7, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.ADC, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.ROR, mode: 11, size: 2, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 11, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.PLA, mode: 6, size: 1, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ADC, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ROR, mode: 4, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ARR, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.JMP, mode: 8, size: 3, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.ADC, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ROR, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 1, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.BVS, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.ADC, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 9, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ADC, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.ROR, mode: 12, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 12, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SEI, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ADC, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 3, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.ADC, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.ROR, mode: 2, size: 3, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.RRA, mode: 2, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.STA, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SAX, mode: 7, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.STY, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.STA, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.STX, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.SAX, mode: 11, size: 0, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.DEY, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.TXA, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.XAA, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.STY, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.STA, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.STX, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.SAX, mode: 1, size: 0, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.BCC, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.STA, mode: 9, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.AHX, mode: 9, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.STY, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.STA, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.STX, mode: 13, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.SAX, mode: 13, size: 0, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.TYA, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.STA, mode: 3, size: 3, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.TXS, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.TAS, mode: 3, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.SHY, mode: 2, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.STA, mode: 2, size: 3, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.SHX, mode: 3, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.AHX, mode: 3, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.LDY, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LDA, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.LDX, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LAX, mode: 7, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.LDY, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.LDA, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.LDX, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.LAX, mode: 11, size: 0, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.TAY, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LDA, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.TAX, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LAX, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LDY, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LDA, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LDX, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LAX, mode: 1, size: 0, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.BCS, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.LDA, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LAX, mode: 9, size: 0, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.LDY, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LDA, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LDX, mode: 13, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.LAX, mode: 13, size: 0, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.CLV, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LDA, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.TSX, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.LAS, mode: 3, size: 0, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.LDY, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.LDA, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.LDX, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.LAX, mode: 3, size: 0, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.CPY, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.CMP, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 7, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.CPY, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.CMP, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.DEC, mode: 11, size: 2, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 11, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.INY, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.CMP, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.DEX, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.AXS, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.CPY, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.CMP, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.DEC, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 1, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.BNE, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.CMP, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 9, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.CMP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.DEC, mode: 12, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 12, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.CLD, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.CMP, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 3, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.CMP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.DEC, mode: 2, size: 3, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.DCP, mode: 2, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.CPX, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 7, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 7, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.CPX, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 11, size: 2, cycle: 3, cycleXPage: 0),
  OP(opcode: OPCODE.INC, mode: 11, size: 2, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 11, size: 0, cycle: 5, cycleXPage: 0),
  OP(opcode: OPCODE.INX, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 5, size: 2, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 5, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.CPX, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 1, size: 3, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.INC, mode: 1, size: 3, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 1, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.BEQ, mode: 10, size: 2, cycle: 2, cycleXPage: 1),
  OP(opcode: OPCODE.SBC, mode: 9, size: 2, cycle: 5, cycleXPage: 1),
  OP(opcode: OPCODE.KIL, mode: 6, size: 0, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 9, size: 0, cycle: 8, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 12, size: 2, cycle: 4, cycleXPage: 0),
  OP(opcode: OPCODE.INC, mode: 12, size: 2, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 12, size: 0, cycle: 6, cycleXPage: 0),
  OP(opcode: OPCODE.SED, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.SBC, mode: 3, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.NOP, mode: 6, size: 1, cycle: 2, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 3, size: 0, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.NOP, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.SBC, mode: 2, size: 3, cycle: 4, cycleXPage: 1),
  OP(opcode: OPCODE.INC, mode: 2, size: 3, cycle: 7, cycleXPage: 0),
  OP(opcode: OPCODE.ISC, mode: 2, size: 0, cycle: 7, cycleXPage: 0)
]


enum AddressMode: Int {
  case
  Absolute = 1,
  AbsoluteX,
  AbsoluteY,
  Accumulator,
  Immediate,
  Implied,
  IndexedIndirect,
  Indirect,
  IndirectIndexed,
  Relative,
  ZeroPage,
  ZeroPageX,
  ZeroPageY
}

// instructions
// for instruction table see cpu_instr_table.swift
struct OP {
  let opcode: OPCODE
  let mode: Int
  let size: Int // in bytes
  let cycle: Int
  let cycleXPage: Int
  
  func exec(cpu: CPU, ram:RAM) -> Int {
    let addrMode = AddressMode(rawValue: mode)
    var pageX = false
    var addr: UInt16 = 0
    switch(addrMode!) {
    case .Absolute:
      addr = ram.read2Byte(cpu.PC &+ 1)
    case .AbsoluteX:
      addr = ram.read2Byte(cpu.PC &+ 1) &+ UInt16(cpu.X)
      pageX = RAM.pageXAt(addr &- UInt16(cpu.X), fromAddr: addr)
    case .AbsoluteY:
      addr = ram.read2Byte(cpu.PC &+ 1) &+ UInt16(cpu.Y)
      pageX = RAM.pageXAt(addr &- UInt16(cpu.Y), fromAddr: addr)
    case .Indirect:
      addr = ram.read2ByteBug(ram.read2Byte(cpu.PC &+ 1))
    case .IndexedIndirect:
      addr = ram.read2ByteBug(UInt16(ram.readByte(cpu.PC &+ 1) &+ cpu.X))
    case .IndirectIndexed:
      addr = ram.read2ByteBug(UInt16(ram.readByte(cpu.PC &+ 1))) &+ UInt16(cpu.Y)
      pageX = RAM.pageXAt(addr &- UInt16(cpu.Y), fromAddr: addr)
    case .Relative:
      let offset = UInt16(ram.readByte(cpu.PC &+ 1))
      addr = offset <  0x80 ? cpu.PC &+ 2 &+ offset : cpu.PC &+ 2 &+ offset &- 0x100
    case .ZeroPage:
      addr = UInt16(ram.readByte(cpu.PC &+ 1))
    case .ZeroPageX:
      addr = UInt16(ram.readByte(cpu.PC &+ 1) &+ cpu.X)
    case .ZeroPageY:
      addr = UInt16(ram.readByte(cpu.PC &+ 1) &+ cpu.Y)
    case .Immediate:
      addr = cpu.PC &+ 1
    case .Accumulator:
      fallthrough
    case .Implied:
      addr = 0
    }
    // count the the cpu cycle to incr
    var cycleDelta = !pageX ? cycle : cycle + cycleXPage
    // print(" \(self.opcode): \(addrMode!) \(addr.hex)", terminator: " ")
    // move PC to the OP
    cpu.PC += UInt16(size)
    // actuall do the OP
    switch (opcode) {
    // This instruction adds the contents of a memory location to the
    // accumulator together with the carry bit. If overflow occurs the
    // carry bit is set, this enables multiple byte addition to be
    // performed.
    //
    //         C 	Carry Flag 	  Set if overflow in bit 7
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Set if sign bit is incorrect
    //         N 	Negative Flag 	  Set if bit 7 set
    case .ADC:
      let operand = ram.readByte(addr)
      
      let acc = cpu.A
      let carry : UInt8 = cpu.getStatusC() ? 1 : 0
      cpu.A = acc &+ operand &+ carry
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      if Int(acc) + Int(operand) + Int(carry) > 0xff {
        cpu.setStatusC(true)
      } else {
        cpu.setStatusC(false)
      }
      // basically signed overflow
      // acc and add have same sign and different from the result
      if (acc^operand) & 0x80 == 0 && (acc^cpu.A) & 0x80 != 0 {
        cpu.setStatusV(true)
      } else {
        cpu.setStatusV(false)
      }
    // A logical AND is performed, bit by bit, on the accumulator contents
    // using the contents of a byte of memory.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 set
    case .AND:
      let operand = ram.readByte(addr)
      cpu.A = cpu.A & operand
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A&0x80 != 0)
    // This operation shifts all the bits of the memory contents one bit
    // left. Bit 0 is set to 0 and bit 7 is placed in the carry flag. The
    // effect of this operation is to multiply the memory contents by 2
    // (ignoring 2's complement considerations), setting the carry if the
    // result will not fit in 8 bits.
    //
    //         C 	Carry Flag 	  Set to contents of old bit 7
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .ASL:
      var operand: UInt8
      if addrMode == .Accumulator {
        cpu.setStatusC((cpu.A >> 7) & 1 != 0)
        cpu.A <<= 1
        operand = cpu.A
      } else {
        operand = ram.readByte(addr)
        cpu.setStatusC((operand >> 7) & 1 != 0)
        operand <<= 1
        ram.writeByte(addr, value: operand)
      }
      cpu.setStatusZ(operand == 0)
      cpu.setStatusN(operand & 0x80 != 0)
    // If the carry flag is clear then add the relative displacement to
    // the program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BCC:
      if !cpu.getStatusC() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
    // If the carry flag is set then add the relative displacement to the
    // program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BCS:
      if cpu.getStatusC() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
    // If the zero flag is set then add the relative displacement to the
    // program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BEQ:
      if cpu.getStatusZ() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
    // This instructions is used to test if one or more bits are set in a
    // target memory location. The mask pattern in A is ANDed with the
    // value in memory to set or clear the zero flag, but the result is
    // not kept. Bits 7 and 6 of the value from memory are copied into the
    // N and V flags.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if the result if the AND is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Set to bit 6 of the memory value
    //         N 	Negative Flag 	  Set to bit 7 of the memory value
    case .BIT:
      let operand = ram.readByte(addr)
      cpu.setStatusZ(operand & cpu.A == 0)
      cpu.setStatusV((operand >> 6) & 1 != 0)
      cpu.setStatusN(operand & 0x80 != 0)
    // If the negative flag is set then add the relative displacement to
    // the program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BMI:
      if cpu.getStatusN() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
    // If the zero flag is clear then add the relative displacement to the
    // program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BNE:
      if !cpu.getStatusZ() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
    // If the negative flag is clear then add the relative displacement to
    // the program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BPL:
      if !cpu.getStatusN() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
      
    // The BRK instruction forces the generation of an interrupt
    // request. The program counter and processor status are pushed on the
    // stack then the IRQ interrupt vector at $FFFE/F is loaded into the
    // PC and the break flag in the status set to one.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Set to 1
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BRK:
      cpu.push2Byte(cpu.PC, ram:ram)
      cpu.pushByte(cpu.P | StatusBit.B.rawValue | StatusBit.U.rawValue, ram: ram)// .PHP
      cpu.setStatusI(true)// .SEI
      cpu.PC = ram.read2Byte(0xfffe)
      
    // If the overflow flag is clear then add the relative displacement to
    // the program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BVC:
      if !cpu.getStatusV() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
      
    // If the overflow flag is set then add the relative displacement to
    // the program counter to cause a branch to a new location.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .BVS:
      if cpu.getStatusV() {
        let oldPC = cpu.PC
        cpu.PC = addr
        cycleDelta += 1
        if RAM.pageXAt(oldPC, fromAddr: addr) {
          cycleDelta += 1
        }
      }
      
    // Set the carry flag to zero.
    //
    //         C 	Carry Flag 	  Set to 0
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .CLC:
      cpu.setStatusC(false)
      
    // Set the decimal mode flag to zero.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Set to 0
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .CLD:
      cpu.setStatusD(false)
      
    // Clears the interrupt disable flag allowing normal interrupt
    // requests to be serviced.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Set to 0
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .CLI:
      cpu.setStatusI(false)
      
    // Clears the interrupt disable flag allowing normal interrupt
    // requests to be serviced.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Set to 0
    //         N 	Negative Flag 	  Not affected
    case .CLV:
      cpu.setStatusV(false)
      
    // This instruction compares the contents of the accumulator with
    // another memory held value and sets the zero and carry flags as
    // appropriate.
    //
    //         C 	Carry Flag 	  Set if A >= M
    //         Z 	Zero Flag 	  Set if A = M
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .CMP:
      let operand = ram.readByte(addr)
      let d = Int(cpu.A) - Int(operand)
      cpu.setStatusZ(d == 0)
      cpu.setStatusN(d & 0x80 != 0)
      cpu.A >= operand ? cpu.setStatusC(true) : cpu.setStatusC(false)
      
    // This instruction compares the contents of the X register with
    // another memory held value and sets the zero and carry flags as
    // appropriate.
    //
    //         C 	Carry Flag 	  Set if X >= M
    //         Z 	Zero Flag 	  Set if X = M
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .CPX:
      let operand = ram.readByte(addr)
      let d = Int(cpu.X) - Int(operand)
      cpu.setStatusZ(d == 0)
      cpu.setStatusN(d & 0x80 != 0)
      cpu.X >= operand ? cpu.setStatusC(true) : cpu.setStatusC(false)

    // This instruction compares the contents of the Y register with
    // another memory held value and sets the zero and carry flags as
    // appropriate.
    //
    //         C 	Carry Flag 	  Set if Y >= M
    //         Z 	Zero Flag 	  Set if Y = M
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .CPY:
      let operand = ram.readByte(addr)
      let d = Int(cpu.Y) - Int(operand)
      cpu.setStatusZ(d == 0)
      cpu.setStatusN(d & 0x80 != 0)
      cpu.Y >= operand ? cpu.setStatusC(true) : cpu.setStatusC(false)

      
    // Subtracts one from the value held at a specified memory location
    // setting the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if result is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .DEC:
      let v = ram.readByte(addr) &- 1
      ram.writeByte(addr, value: v)
      cpu.setStatusZ(v == 0)
      cpu.setStatusN(v & 0x80 != 0)

    // Subtracts one from the X register setting the zero and negative
    // flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if X is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of X is set
    case .DEX:
      cpu.X = cpu.X &- 1
      cpu.setStatusZ(cpu.X == 0)
      cpu.setStatusN(cpu.X & 0x80 != 0)
      
    // Subtracts one from the Y register setting the zero and negative
    // flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if Y is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of Y is set
    case .DEY:
      cpu.Y = cpu.Y &- 1
      cpu.setStatusZ(cpu.Y == 0)
      cpu.setStatusN(cpu.Y & 0x80 != 0)
      
    // An exclusive OR is performed, bit by bit, on the accumulator
    // contents using the contents of a byte of memory.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 set
    case .EOR:
      cpu.A = cpu.A ^ ram.readByte(addr)
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)

    // Adds one to the value held at a specified memory location setting
    // the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if result is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .INC:
      let operand = ram.readByte(addr) &+ 1
      ram.writeByte(addr, value: operand)
      cpu.setStatusZ(operand == 0)
      cpu.setStatusN(operand & 0x80 != 0)
      
    // Adds one to the X register setting the zero and negative flags as
    // appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if X is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of X is set
    case .INX:
      cpu.X = cpu.X &+ 1
      cpu.setStatusZ(cpu.X == 0)
      cpu.setStatusN(cpu.X & 0x80 != 0)
      
    // Adds one to the Y register setting the zero and negative flags as
    // appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if Y is zero
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of Y is set
    case .INY:
      cpu.Y = cpu.Y &+ 1
      cpu.setStatusZ(cpu.Y == 0)
      cpu.setStatusN(cpu.Y & 0x80 != 0)

    // Sets the program counter to the address specified by the operand.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .JMP:
      cpu.PC = addr
      
    // The JSR instruction pushes the address (minus one) of the return
    // point on to the stack and then sets the program counter to the
    // target memory address.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .JSR:
      cpu.push2Byte(cpu.PC &- 1, ram: ram)
      cpu.PC = addr
      
    // Loads a byte of memory into the accumulator setting the zero and
    // negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of A is set
    case .LDA:
      cpu.A = ram.readByte(addr)
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      
    // Loads a byte of memory into the X register setting the zero and
    // negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if X = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of X is set
    case .LDX:
      cpu.X = ram.readByte(addr)
      cpu.setStatusZ(cpu.X == 0)
      cpu.setStatusN(cpu.X & 0x80 != 0)

    // Loads a byte of memory into the Y register setting the zero and
    // negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if Y = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of Y is set
    case .LDY:
      cpu.Y = ram.readByte(addr)
      cpu.setStatusZ(cpu.Y == 0)
      cpu.setStatusN(cpu.Y & 0x80 != 0)

    // Each of the bits in M is shift one place to the right. The bit that
    // was in bit 0 is shifted into the carry flag. Bit 7 is set to zero.
    //
    //         C 	Carry Flag 	  Set to contents of old bit 0
    //         Z 	Zero Flag 	  Set if result = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .LSR:
      var operand: UInt8
      if addrMode == .Accumulator {
        cpu.setStatusC(cpu.A & 1 != 0 )
        cpu.A >>= 1
        operand = cpu.A
      } else {
        operand = ram.readByte(addr)
        cpu.setStatusC(operand & 1 != 0)
        operand >>= 1
        ram.writeByte(addr, value: operand)
      }
      cpu.setStatusZ(operand == 0)
      cpu.setStatusN(operand & 0x80 != 0)
      
    // The NOP instruction causes no changes to the processor other than
    // the normal incrementing of the program counter to the next
    // instruction.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .NOP:
      break
    
    // An inclusive OR is performed, bit by bit, on the accumulator
    // contents using the contents of a byte of memory.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 set
    case .ORA:
      cpu.A = cpu.A | ram.readByte(addr)
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      
    // Pushes a copy of the accumulator on to the stack.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .PHA:
      cpu.pushByte(cpu.A, ram: ram)
    
    // Pushes a copy of the status flags on to the stack.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .PHP:
      cpu.pushByte(cpu.P | StatusBit.B.rawValue | StatusBit.U.rawValue, ram: ram) // set B and U
    
    // Pulls an 8 bit value from the stack and into the accumulator. The
    // zero and negative flags are set as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of A is set
    case .PLA:
      cpu.A = cpu.popByte(ram)
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      
    // Pulls an 8 bit value from the stack and into the processor
    // flags. The flags will take on new states as determined by the value
    // pulled.
    //
    //         C 	Carry Flag 	  Set from stack
    //         Z 	Zero Flag 	  Set from stack
    //         I 	Interrupt Disable Set from stack
    //         D 	Decimal Mode Flag Set from stack
    //         B 	Break Command 	  Set from stack
    //         V 	Overflow Flag 	  Set from stack
    //         N 	Negative Flag 	  Set from stack
    case .PLP:
      cpu.P = cpu.popByte(ram) & 0xef | 0x20 // unset B and U
      
    // Move each of the bits in A one place to the left. Bit 0 is filled
    // with the current value of the carry flag whilst the old bit 7
    // becomes the new carry flag value.
    //
    //         C 	Carry Flag 	  Set to contents of old bit 7
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .ROL:
      var operand: UInt8
      let c: UInt8 = cpu.getStatusC() ? 1 : 0
      if addrMode == .Accumulator {
        cpu.setStatusC((cpu.A >> 7) & 1 != 0)
        cpu.A = (cpu.A << 1) | c
        operand = cpu.A
      } else {
        operand = ram.readByte(addr)
        cpu.setStatusC((operand >> 7) & 1 != 0)
        operand = (operand << 1) | c
        ram.writeByte(addr, value: operand)
      }
      cpu.setStatusZ(operand == 0)
      cpu.setStatusN(operand & 0x80 != 0)
      
    // Move each of the bits in M one place to the right. Bit 7 is filled
    // with the current value of the carry flag whilst the old bit 0
    // becomes the new carry flag value.
    //
    //         C 	Carry Flag 	  Set to contents of old bit 0
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of the result is set
    case .ROR:
      var operand: UInt8
      let c: UInt8 = cpu.getStatusC() ? 1 : 0
      if addrMode == .Accumulator {
        cpu.setStatusC(cpu.A & 1 != 0)
        cpu.A = (cpu.A >> 1) | (c << 7)
        operand = cpu.A
      } else {
        operand = ram.readByte(addr)
        cpu.setStatusC(operand & 1 != 0)
        operand = (operand >> 1) | (c << 7)
        ram.writeByte(addr, value: operand)
      }
      cpu.setStatusZ(operand == 0)
      cpu.setStatusN(operand & 0x80 != 0)
      
    // The RTI instruction is used at the end of an interrupt processing
    // routine. It pulls the processor flags from the stack followed by
    // the program counter.
    //
    //         C 	Carry Flag 	  Set from stack
    //         Z 	Zero Flag 	  Set from stack
    //         I 	Interrupt Disable Set from stack
    //         D 	Decimal Mode Flag Set from stack
    //         B 	Break Command 	  Set from stack
    //         V 	Overflow Flag 	  Set from stack
    //         N 	Negative Flag 	  Set from stack
    case .RTI:
      cpu.P = cpu.popByte(ram) & 0xef | 0x20 // unset B and U
      cpu.PC = cpu.pop2Byte(ram)
      
    // The RTS instruction is used at the end of a subroutine to return to
    // the calling routine. It pulls the program counter (minus one) from
    // the stack.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .RTS:
      cpu.PC = cpu.pop2Byte(ram) + 1
      
    // This instruction subtracts the contents of a memory location to the
    // accumulator together with the not of the carry bit. If overflow
    // occurs the carry bit is clear, this enables multiple byte
    // subtraction to be performed.
    //
    //         C 	Carry Flag 	  Clear if overflow in bit 7
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Set if sign bit is incorrect
    //         N 	Negative Flag 	  Set if bit 7 set
    case .SBC:
      let acc = cpu.A
      let operand = ram.readByte(addr)
      let carry: UInt8 = cpu.getStatusC() ? 1 : 0
      let o = Int(acc) - Int(operand) - (1 - Int(carry))
      cpu.A = acc &- operand &- ( 1 &- carry)
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      if o >= 0 {
        cpu.setStatusC(true)
      } else {
        cpu.setStatusC(false)
      }

      if (acc^operand) & 0x80 != 0 && (acc^cpu.A) & 0x80 != 0 {
        cpu.setStatusV(true)
      } else {
        cpu.setStatusV(false)
      }
      
    // Set the carry flag to one.
    //
    //         C 	Carry Flag 	  Set to 1
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .SEC:
      cpu.setStatusC(true)
      
    // Set the decimal mode flag to one.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Set to 1
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .SED:
      cpu.setStatusD(true)
    
    // Set the interrupt disable flag to one.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Set to 1
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .SEI:
      cpu.setStatusI(true)
    
    // Stores the contents of the accumulator into memory.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .STA:
      ram.writeByte(addr, value: cpu.A)
      
    // Stores the contents of the X register into memory.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .STX:
      ram.writeByte(addr, value: cpu.X)
      
    // Stores the contents of the Y register into memory.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .STY:
      ram.writeByte(addr, value: cpu.Y)
      
    // Copies the current contents of the accumulator into the X register
    // and sets the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if X = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of X is set
    case .TAX:
      cpu.X = cpu.A
      cpu.setStatusZ(cpu.X == 0)
      cpu.setStatusN(cpu.X & 0x80 != 0)
      
    // Copies the current contents of the accumulator into the Y register
    // and sets the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if Y = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of Y is set
    case .TAY:
      cpu.Y = cpu.A
      cpu.setStatusZ(cpu.Y == 0)
      cpu.setStatusN(cpu.Y & 0x80 != 0)
      
    // Copies the current contents of the stack register into the X
    // register and sets the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if X = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of X is set
    case .TSX:
      cpu.X = cpu.SP
      cpu.setStatusZ(cpu.X == 0)
      cpu.setStatusN(cpu.X & 0x80 != 0)
      
    // Copies the current contents of the X register into the accumulator
    // and sets the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of A is set
    case .TXA:
      cpu.A = cpu.X
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      
    // Copies the current contents of the X register into the stack
    // register.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Not affected
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Not affected
    case .TXS:
      cpu.SP = cpu.X
      
    // Copies the current contents of the Y register into the accumulator
    // and sets the zero and negative flags as appropriate.
    //
    //         C 	Carry Flag 	  Not affected
    //         Z 	Zero Flag 	  Set if A = 0
    //         I 	Interrupt Disable Not affected
    //         D 	Decimal Mode Flag Not affected
    //         B 	Break Command 	  Not affected
    //         V 	Overflow Flag 	  Not affected
    //         N 	Negative Flag 	  Set if bit 7 of A is set
    case .TYA:
      cpu.A = cpu.Y
      cpu.setStatusZ(cpu.A == 0)
      cpu.setStatusN(cpu.A & 0x80 != 0)
      
    // unofficial
    case .AHX, .ALR, .ANC, .ARR, .AXS, .DCP, .ISC, .KIL, .LAS, .LAX, .RLA, .RRA, .SAX, .SHX, .SHY, .SLO, .SRE, .TAS, .XAA:
      break
    }
    
    return cycleDelta
  }
}
