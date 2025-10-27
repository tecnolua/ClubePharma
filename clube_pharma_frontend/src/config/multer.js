import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Criar diretório de uploads se não existir
const uploadsDir = path.join(__dirname, '../../uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

// Criar subdiretórios para receitas e exames
const prescriptionsDir = path.join(uploadsDir, 'prescriptions');
const examsDir = path.join(uploadsDir, 'exams');

if (!fs.existsSync(prescriptionsDir)) {
  fs.mkdirSync(prescriptionsDir, { recursive: true });
}

if (!fs.existsSync(examsDir)) {
  fs.mkdirSync(examsDir, { recursive: true });
}

// Configuração de storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Define o diretório baseado no tipo de upload
    const uploadType = req.baseUrl.includes('prescriptions') ? 'prescriptions' : 'exams';
    const dest = path.join(uploadsDir, uploadType);
    cb(null, dest);
  },
  filename: (req, file, cb) => {
    // Gera nome único: timestamp_userId_originalname
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const sanitizedOriginalName = file.originalname.replace(/[^a-zA-Z0-9.-]/g, '_');
    cb(null, `${uniqueSuffix}_${req.user.id}_${sanitizedOriginalName}`);
  }
});

// Filtro de tipos de arquivo permitidos
const fileFilter = (req, file, cb) => {
  const allowedMimes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
    'application/pdf'
  ];

  if (allowedMimes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only JPG, PNG, GIF, WEBP and PDF are allowed.'), false);
  }
};

// Configuração do Multer
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB max
  }
});

export default upload;
